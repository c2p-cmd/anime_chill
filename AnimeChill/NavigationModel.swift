//
//  NavigationModel.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import SwiftUI

enum Routes: Hashable {
    case searchResults([SearchModel])
    case videoPlayer(id: String, url: String)
    
    var view: some View {
        switch self {
        case .videoPlayer(let id, let url):
            EmptyView()
        }
    }
}

@Observable
class NavigationModel {
    static let shared = NavigationModel()
    
    var path = NavigationPath()
    
    func push(to route: Routes) { path.append(route) }
    
    func pop() { path.removeLast() }
    
    func goHome() { path.removeLast(path.count) }
}
