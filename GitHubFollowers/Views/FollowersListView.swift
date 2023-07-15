//
//  FollowersListView.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 13.07.23.
//

import SwiftUI

struct FollowersListView: View {
    let username: String
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @State private var followers: [Follower] = []
    @State private var page = 1
    @State private var hasMoreFollowers = true
    
    private var filteredFollowers: [Follower] {
        let sanitisedText = searchText.trimmingCharacters(in: .whitespaces)
        guard !sanitisedText.isEmpty else {
            return followers
        }
        
        return followers.filter { $0.login.lowercased().contains(sanitisedText.lowercased()) }
    }
    
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(filteredFollowers, id: \.id) { follower in
                    FollowerView(follower: follower)
                }
            }
            
            if hasMoreFollowers {
                Button {
                    loadMoreFollowers()
                } label: {
                    Label("Load more followers", systemImage: "person.badge.plus")
                }
            }
        }
        .task {
            await getFollowers()
        }
        .searchable(text: $searchText, isPresented: $searchIsActive)
        .navigationTitle(username)
    }
    
    private func getFollowers() async {
        do {
            let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
            
            if followers.count < 100 {
                hasMoreFollowers = false
            }
            
            self.followers.append(contentsOf: followers)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadMoreFollowers() {
        guard hasMoreFollowers else { return }
        page += 1
        
        Task {
            await getFollowers()
        }
    }
}

#Preview {
    FollowersListView(username: "filippolobisch")
        .preferredColorScheme(.dark)
}
