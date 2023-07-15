//
//  AppTabView.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 15.07.23.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}
