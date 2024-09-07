//
//  MovieInfoView.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import SwiftUI

struct MovieInfoView: View {
    let movie: SearchModel
    
    var movieId: String { movie.id }
    
    @Environment(NavigationModel.self) var navModel
    @State private var vm = ViewModel()
    
    var body: some View {
        ScrollView {
            if vm.isBusy {
                ProgressView()
                    .frame(height: 100)
                    .progressViewStyle(.circular)
            }
            
            if let movie = vm.movie {
                movie.coverImage
                    .aspectRatio(contentMode: .fit)
                
                Text("Released on **\(movie.releaseDate)**")
                    .font(.subheadline)
                
                genresView(genres: movie.genres)
                
                Text(movie.description)
                    .font(.callout)
                    .padding(.horizontal)
                
                Picker("", selection: $vm.selectedSection) {
                    ForEach(Sections.allCases) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                
                switch vm.selectedSection {
                case .episodes:
                    episodesList(episodes: movie.episodes)
                        .sheet(item: $vm.selectedEpisode) { ep in
                            EpisodesStreamingSheet(episode: ep, media: movieId)
//                                .environment(navModel)
                                .presentationDetents([.fraction(0.33), .medium])
                        }
                case .recommendations:
                    recommendationList(recommendations: movie.recommendations)
                }
            }
        }
        .navigationTitle(movie.title)
        .toolbar {
            let isFavourite = vm.isInFavourites(searchModel: movie)
            Button("Favourite", systemImage: isFavourite ? "star.fill" : "star") {
                vm.addToFavourites(searchModel: movie)
            }
            .tint(.yellow)
            .symbolEffect(.scale.up.byLayer)
        }
        .task {
            await self.vm.fetch(id: movieId)
        }
    }
    
    func genresView(genres: [String]) -> some View {
        ScrollView(.horizontal) {
            HStack {
                Text("Genres: ")
                
                ForEach(genres, id: \.self) {
                    Text($0)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
        .safeAreaPadding(.horizontal)
    }
    
    func episodesList(episodes: [EpisodesModel]) -> some View {
        ForEach(episodes) { (ep: EpisodesModel) in
            Button {
                self.vm.selectedEpisode = ep
            } label: {
                let season = ep.season != nil ? "S\(ep.season!) " : ""
                let number = ep.number != nil ? "E\(ep.number!): " : ""
                let title = season + number + ep.title
                
                HStack {
                    Text(title)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right.circle.fill")
                }
            }
            .buttonStyle(BorderedButtonStyle())
            .padding()
        }
    }
    
    func recommendationList(recommendations: [MovieInfoModel.Recommendations]) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible(minimum: 100, maximum: 200)),
            GridItem(.flexible(minimum: 100, maximum: 200)),
        ]) {
            ForEach(recommendations) { (r: MovieInfoModel.Recommendations) in
                VStack(alignment: .center, spacing: 6) {
                    AsyncImage(url: URL(string: r.image)) {
                        $0.resizable()
                    } placeholder: {
                        ProgressView()
                            .frame(height: 100)
                    }
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 10, style: .continuous))
                    
                    Text(r.title)
                        .font(.headline)
                }
            }
        }
        .safeAreaPadding(.horizontal)
    }
}

extension MovieInfoView {
    enum Sections: String, Identifiable, CaseIterable {
        var id: Self { self }
        
        case episodes = "Episodes"
        case recommendations = "Recommendations"
    }
    
    @Observable
    class ViewModel {
        var movie: MovieInfoModel?
        
        var selectedEpisode: EpisodesModel?
        var selectedSection: Sections = .episodes
        
        var error: AppError?
        
        var isBusy = false
        
        var showError: Bool {
            get { self.error != nil }
            set { self.error = nil }
        }
        
        func fetch(id: String) async {
            if isBusy { return }
            
            isBusy = true
            let api: API = .movieInfo(id: id)
            let task = api.fetch(ofType: MovieInfoModel.self)
            
            let result = await task.result
            
            withAnimation {
                switch result {
                case .success(let success):
                    self.movie = success
                case .failure(let failure):
                    self.error = failure as? AppError
                }
                isBusy = false
            }
        }
        
        func isInFavourites(searchModel: SearchModel) -> Bool {
            guard let data = UserDefaults.standard.data(forKey: "Favourites") else { return false }
            guard let favs = try? JSONDecoder().decode([SearchModel].self, from: data) else { return false }
            return favs.contains(searchModel)
        }
        
        func addToFavourites(searchModel: SearchModel) {
            guard !isInFavourites(searchModel: searchModel) else { return }
            
            var favs: [SearchModel] = []
            if let data = UserDefaults.standard.data(forKey: "Favourites"),
               let storedFavs = try? JSONDecoder().decode([SearchModel].self, from: data) {
                favs = storedFavs
            }
            favs.append(searchModel)
            isBusy = true
            if let encodedData = try? JSONEncoder().encode(favs) {
                UserDefaults.standard.set(encodedData, forKey: "Favourites")
            }
            isBusy = false
        }
    }
}

fileprivate struct EpisodesStreamingSheet: View {
    let episode: EpisodesModel
    let media: String
    
    @Environment(NavigationModel.self) var navigationModel
    @Environment(\.dismiss) var dismiss
    
    @State private var streamingLinks: [StreamingLinksModel] = []
    @State private var error: String?
    @State private var isBusy = false
    
    var body: some View {
        List {
            Text(episode.title)
                .font(.title3.bold())
            
            if isBusy {
                ProgressView()
            }
            
            if let error {
                Text(error)
                    .font(.title2)
                    .foregroundStyle(.red)
            }
            
            ForEach(streamingLinks) { link in
                let season = episode.season != nil ? "S\(episode.season!) " : ""
                let number = episode.number != nil ? "E\(episode.number!): " : ""
                let title = season + number + episode.title
                let route = Routes.videoPlayer(id: title, url: link.url)
                Button {
                    dismiss.callAsFunction()
                    navigationModel.push(to: route)
                } label: {
                    HStack {
                        Text(link.quality)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                }
            }
        }
        .task {
            self.isBusy = true
            let api: API = .streamingLinks(episode: episode.id, media: media)
            let task = api.fetch(ofType: StreamingLinksResult.self)
            
            switch await task.result {
            case .success(let success):
                self.streamingLinks = success.sources
            case .failure(let failure):
                self.error = failure.localizedDescription
            }
            self.isBusy = false
        }
    }
}

#Preview {
    NavigationStack {
        MovieInfoView(movie: .mockOne())
            .environment(NavigationModel())
    }
}
