//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 07/10/2021.
//

import Foundation

struct Follower: Codable, Hashable, Identifiable {
    var id: String { login }
    
    let login: String
    let avatarUrl: String
}
