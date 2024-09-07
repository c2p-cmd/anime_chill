//
//  MovieInfoView.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import SwiftUI

struct MovieInfoView: View {
    let movieId: String
    
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
#if !os(macOS)
                    .frame(height: 200)
#endif
                    .aspectRatio(contentMode: .fill)
                
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
                        .sheet(item: $vm.selectedEpisode) {
                            EpisodesStreamingSheet(episode: $0, media: movieId)
                        }
                case .recommendations:
                    recommendationList(recommendations: movie.recommendations)
                }
            }
        }
        .navigationTitle(vm.movie?.title ?? movieId)
        .task {
#if DEBUG
            self.vm.movie = .mockOne()
            self.vm.isBusy = false
#else
            await self.vm.fetch(id: movieId)
#endif
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
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    
                    Text(r.title)
                        .font(.headline)
                }
            }
        }
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
            }
        }
    }
}

fileprivate struct EpisodesStreamingSheet: View {
    let episode: EpisodesModel
    let media: String
    
    @State private var streamingLinks: [StreamingLinksModel] = []
    @State private var error: String?
    @State private var isBusy = false
    
    var body: some View {
        VStack {
            Text(episode.title)
                .font(.title.bold())
            
            if isBusy {
                ProgressView()
            }
            
            if let error {
                Text(error)
                    .font(.title2)
                    .foregroundStyle(.red)
            }
            
            List(streamingLinks) { link in
                let route = Routes.videoPlayer(id: link.id, url: link.url)
                NavigationLink(link.quality, value: route)
            }
        }
        .padding(.top)
        .task {
            self.isBusy = true
            let api: API = .streamingLinks(episode: episode.id, media: media)
            let task = api.fetch(ofType: [StreamingLinksModel].self)
            
            switch await task.result {
            case .success(let success):
                self.streamingLinks = success
            case .failure(let failure):
                self.error = failure.localizedDescription
            }
            self.isBusy = false
        }
    }
}

#Preview {
    NavigationStack {
        MovieInfoView(movieId: "tv/watch-the-flash-39535")
    }
}
