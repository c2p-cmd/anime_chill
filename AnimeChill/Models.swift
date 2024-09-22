//
//  Models.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import SwiftUI

struct SearchModelPaginated: Decodable {
    let currentPage: Int
    let hasNextPage: Bool
    let results: [SearchModel]
}

struct SearchModel: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let image: String
    let type: String
    let seasons: Int?
    let releaseDate: String?
}

struct MovieInfoModel: Identifiable, Decodable, Hashable {
    let id: String
    let title: String
    let cover: String
    let image: String
    let description: String
    let type: String
    let releaseDate: String
    let genres: [String]
    let recommendations: [Recommendations]
    let episodes: [EpisodesModel]
    
    struct Recommendations: Identifiable, Decodable, Hashable {
        let id: String
        let title: String
        let image: String
        let type: String
        
        var searchModel: SearchModel {
            SearchModel(
                id: id,
                title: title,
                image: image,
                type: type,
                seasons: nil,
                releaseDate: nil
            )
        }
    }
    
    var coverImage: some View {
        AsyncImage(url: URL(string: cover.isEmpty ? image : cover)) {
            $0.resizable()
        } placeholder: {
            ProgressView()
                .frame(height: 100)
                .progressViewStyle(.circular)
        }
    }
}

struct EpisodesModel: Identifiable, Decodable, Hashable {
    let id: String
    let title: String
    let number: Int?
    let season: Int?
}

struct StreamingLinksResult: Decodable, Hashable {
    let sources: [StreamingLinksModel]
}

struct StreamingLinksModel: Identifiable, Decodable, Hashable {
    let url: String
    let quality: String
    
    var id: String {
        self.url
    }
}

extension SearchModel {
    static func mockOne() -> SearchModel {
        .init(
            id: "movie/watch-white-boy-rick-19515",
            title: "White Boy Rick",
            image: "https://img.flixhq.to/xxrz/250x400/379/56/3a/563a8cd71c94319ca1e6ffa75b9b135c/563a8cd71c94319ca1e6ffa75b9b135c.jpg",
            type: "Movie",
            seasons: nil,
            releaseDate: "2018"
        )
    }
}

extension MovieInfoModel {
    static func mockOne() -> MovieInfoModel {
        MovieInfoModel(
            id: "tv/watch-the-flash-39535",
            title: "The Flash",
            cover: "https://img.flixhq.to/xxrz/1200x600/379/71/12/7112e6346759ca8cb89b4a1778c51288/7112e6346759ca8cb89b4a1778c51288.jpg",
            image: "https://img.flixhq.to/xxrz/250x400/379/e4/82/e4825d53072441905e1257c706f4c9c7/e4825d53072441905e1257c706f4c9c7.jpg",
            description: "\n        After a particle accelerator causes a freak storm, CSI Investigator Barry Allen is struck by lightning and falls into a coma. Months later he awakens with the power of super speed, granting him the ability to move through Central City like an unseen guardian angel. Though initially excited by his newfound powers, Barry is shocked to discover he is not the only \"meta-human\" who was created in the wake of the accelerator explosion -- and not everyone is using their new powers for good. Barry partners with S.T.A.R. Labs and dedicates his life to protect the innocent. For now, only a few close friends and associates know that Barry is literally the fastest man alive, but it won't be long before the world learns what Barry Allen has become...The Flash.\n    ",
            type: "TV Series",
            releaseDate: "2014-10-07",
            genres: [
                "Drama",
                "Sci-Fi"
            ],
            recommendations: [
                .init(
                    id: "movie/watch-the-pastor-111166",
                    title: "The Pastor",
                    image: "https://img.flixhq.to/xxrz/250x400/379/cf/98/cf98db6049fd31178a415817f2de796b/cf98db6049fd31178a415817f2de796b.jpg",
                    type: "Movie"
                ),
                .init(
                    id: "movie/watch-the-pastor-116",
                    title: "The Pastor",
                    image: "https://img.flixhq.to/xxrz/250x400/379/cf/98/cf98db6049fd31178a415817f2de796b/cf98db6049fd31178a415817f2de796b.jpg",
                    type: "Movie"
                ),
                .init(
                    id: "movie/watch-the-pastor-1116",
                    title: "The Pastor",
                    image: "https://img.flixhq.to/xxrz/250x400/379/cf/98/cf98db6049fd31178a415817f2de796b/cf98db6049fd31178a415817f2de796b.jpg",
                    type: "Movie"
                ),
                .init(
                    id: "movie/watch-the-pastor-11116",
                    title: "The Pastor",
                    image: "https://img.flixhq.to/xxrz/250x400/379/cf/98/cf98db6049fd31178a415817f2de796b/cf98db6049fd31178a415817f2de796b.jpg",
                    type: "Movie"
                ),
            ],
            episodes: [
                EpisodesModel(id: "2899", title: "Eps 1. City of Heroes", number: 1, season: 1),
            ]
        )
    }
}
