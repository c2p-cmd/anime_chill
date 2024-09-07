//
//  NavigationModel.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import SwiftUI

enum Routes: Hashable, View, Codable {
    case movieInfo(SearchModel)
    case videoPlayer(id: String, url: String)
    
    var body: some View {
        switch self {
        case .movieInfo(let searchModel):
            MovieInfoView(movie: searchModel)
        case .videoPlayer(let id, let url):
            MyVideoPlayer(id: id, url: url)
        }
    }
}

@Observable
class NavigationModel {
    static let shared = NavigationModel()
    
    var path: NavigationPath {
        didSet {
            savePath()
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "NavPath"),
            let representation = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
            self.path = NavigationPath(representation)
        } else {
            self.path = NavigationPath()
        }
    }
    
    func push(to route: Routes) {
        path.append(route)
        savePath()
    }
    
    func pop() {
        path.removeLast()
        savePath()
    }
    
    func goHome() {
        path.removeLast(path.count)
        savePath()
    }
    
    private func savePath() {
        guard let representation = path.codable else { return }
        do {
            let data = try JSONEncoder().encode(representation)
            UserDefaults.standard.set(data, forKey: "NavPath")
        } catch {
            print(error)
        }
    }
}
