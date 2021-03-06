//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 07/10/2021.
//

import Foundation

struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String
}
