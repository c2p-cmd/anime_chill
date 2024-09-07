//
//  ContentView.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import SwiftUI

struct ContentView: View {
    @State var vm = ViewModel()
    
    var body: some View {
        List {
            if let searchResults = vm.searchResults?.results {
                self.searchResults(searchResults)
                    .overlay(alignment: .center) {
                        if searchResults.isEmpty {
                            ContentUnavailableView.search
                        }
                    }
            } else {
                VStack(spacing: 10) {
                    Text("Try searching for something to watch")
                        .font(.headline)
                    
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.largeTitle)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.background, .teal, .secondary)
                        .symbolEffect(.pulse)
                        .symbolEffectsRemoved(!vm.isBusy)
                    
                    if vm.isBusy {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            if !vm.favouriteItems.isEmpty {
                Section("Favourites") {
                    searchResults(vm.favouriteItems)
                }
            }
        }
        .searchable(text: $vm.searchTerm, placement: .toolbar)
        .onSubmit(of: .search, vm.fetch)
        .alert(isPresented: $vm.showError, error: vm.error) { }
        .navigationDestination(for: Routes.self) { $0 }
    }
    
    func searchResults(_ results: [SearchModel]) -> some View {
        ForEach(results) { searchResult in
            let route: Routes = .movieInfo(searchResult)
            
            NavigationLink(value: route) {
                HStack(spacing: 6) {
                    AsyncImage(url: URL(string: searchResult.image)) { image in
                        image.resizable()
                    } placeholder: {
                        Image(systemName: "popcorn.fill")
                            .symbolEffect(.pulse.byLayer)
                    }
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(searchResult.title)
                            .font(.headline)
                        
                        Text(searchResult.type + " " +  (searchResult.releaseDate ?? ""))
                            .font(.subheadline)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .contextMenu {
                Button("Remove From Favourites", systemImage: "star.slash.fill", role: .destructive) {
                    vm.removeFromFavourites(searchModel: searchResult)
                }
            }
        }
    }
}

extension ContentView {
    @Observable
    class ViewModel {
        var searchTerm = ""
        
        var searchResults: SearchModelPaginated?
        
        var favouriteItems: [SearchModel] {
            guard let data = UserDefaults.standard.data(forKey: "Favourites") else {
                return []
            }
            let results = try? JSONDecoder().decode([SearchModel].self, from: data)
            return results ?? []
        }
        
        var error: AppError?
        
        var isBusy = false
        
        var showError: Bool {
            get { self.error != nil }
            set { self.error = nil }
        }
        
        func fetch() {
            Task {
                if self.isBusy { return }
                
                await MainActor.run {
                    self.isBusy = true
                }
                let api: API = .search(query: searchTerm)
                let searchResults = api.fetch(ofType: SearchModelPaginated.self)
                
                switch await searchResults.result {
                case .success(let success):
                    await MainActor.run {
                        withAnimation {
                            self.searchResults = success
                        }
                    }
                case .failure(let failure):
                    await MainActor.run {
                        withAnimation {
                            self.error = failure as? AppError
                        }
                    }
                }
                await MainActor.run {
                    self.isBusy = false
                }
            }
        }
        
        func removeFromFavourites(searchModel: SearchModel) {
            guard let data = UserDefaults.standard.data(forKey: "Favourites") else {
                return
            }
            guard var results = try? JSONDecoder().decode([SearchModel].self, from: data) else { return }
            guard let index = results.firstIndex(of: searchModel) else { return }
            
            results.remove(at: index)
            
            if let encodedData = try? JSONEncoder().encode(results) {
                self.isBusy = true
                UserDefaults.standard.set(encodedData, forKey: "Favourites")
            }
            self.isBusy = false
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .navigationTitle("Popcorny 🍿")
    }
}
