//
//  API.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import SwiftUI

enum API {
    enum Servers: String, RawRepresentable, Identifiable, CaseIterable, CustomStringConvertible {
        case mixdrop = "mixdrop"
        case vidcloud = "vidcloud"
        case upcloud = "upcloud"
        
        var id: Self { self }
        
        var icon: String {
            switch self {
            case .mixdrop:
                "m.circle"
            case .vidcloud:
                "v.circle"
            case .upcloud:
                "u.circle"
            }
        }
        
        var description: String {
            switch self {
                case .mixdrop:
                "Mixdrop"
            case .vidcloud:
                "Vidcloud"
            case .upcloud:
                "Upcloud"
            }
        }
        
        var label: Label<Text, Image> {
            Label(description, systemImage: icon)
        }
    }
    
    // private static let basePath = "https://consumet-api-snowy.vercel.app"
    private static let basePath = "https://my-consumet-api-dvbf.onrender.com"
    
    case search(query: String)
    case movieInfo(id: String)
    case streamingLinks(episode: String, media: String, server: Servers? = nil)
    case availableServers(episode: String, media: String)
    
    var url: URL {
        switch self {
        case .search(let query):
            Self.searchURL(for: query)
        case .movieInfo(let id):
            Self.getMovieInfo(forId: id)
        case .streamingLinks(let episode, let media, let server):
            Self.streamingLinks(forEpisode: episode, media: media, onServer: server)
        case .availableServers(let episode, let media):
            Self.availableServers(forEpisode: episode, media: media)
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
    
    private static func streamingLinks(forEpisode episodeId: String, media mediaId: String, onServer server: Servers?) -> URL {
        URL(string: "\(basePath)/movies/flixhq/watch")!.appending(queryItems: [
            URLQueryItem(name: "episodeId", value: episodeId),
            URLQueryItem(name: "mediaId", value: mediaId),
            URLQueryItem(name: "server", value: server?.rawValue)
        ])
    }
    
    private static func availableServers(forEpisode episodeId: String, media mediaId: String) -> URL {
        URL(string: "\(basePath)/movies/flixhq/servers")!.appending(queryItems: [
            URLQueryItem(name: "episodeId", value: episodeId),
            URLQueryItem(name: "mediaId", value: mediaId)
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
