//
//  API.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import Foundation

enum API {
    private static let basePath = "https://consumet-api-snowy.vercel.app"
    
    case search(query: String)
    case movieInfo(id: String)
    case streamingLinks(episode: String, media: String)
    
    var url: URL {
        switch self {
        case .search(let query):
            Self.searchURL(for: query)
        case .movieInfo(let id):
            Self.getMovieInfo(forId: id)
        case .streamingLinks(let episode, let media):
            Self.streamingLinks(forEpisode: episode, media: media)
        }
    }
    
    private static func searchURL(for query: String) -> URL {
        URL(string: "\(basePath)/movies/flixhq/\(query)")!
    }
    
    private static func getMovieInfo(forId id: String) -> URL {
        URL(string: "\(basePath)/movies/flixhq/info")!.appending(queryItems: [
            URLQueryItem(name: "id", value: id)
        ])
    }
    
    private static func streamingLinks(forEpisode episodeId: String, media mediaId: String) -> URL {
        URL(string: "\(basePath)/movies/flixhq/watch")!.appending(queryItems: [
            URLQueryItem(name: "episodeId", value: episodeId),
            URLQueryItem(name: "mediaId", value: mediaId),
        ])
    }
    
    func fetch<ResponseType: Decodable>(ofType responseType: ResponseType.Type) -> Task<ResponseType, Error> {
        Task {
            let url = self.url
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError("Invalid Response type!")
            }
            
            guard httpResponse.statusCode == 200 else {
                do {
                    let err = try JSONDecoder().decode(AppError.self, from: data)
                    throw err
                } catch {
                    print(error)
                }
                throw AppError("Error receiving data!")
            }
            
            do {
                return try JSONDecoder().decode(ResponseType.self, from: data)
            } catch {
                print(error)
                if let locError = error as? LocalizedError {
                    throw AppError(locError.errorDescription ?? locError.failureReason ?? locError.localizedDescription)
                }
                
                let nsError = error as NSError
                throw AppError(nsError.localizedDescription)
            }
        }
    }
}
