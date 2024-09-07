//
//  AnimeChillApp.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import SwiftUI

@main
struct AnimeChillApp: App {
    @State private var navigationModel = NavigationModel.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationModel.path) {
                ContentView()
                    .navigationTitle("Popcorny 🍿")
            }
            .environment(navigationModel)
        }
    }
}
