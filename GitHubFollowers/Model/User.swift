//
//  User.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 07/10/2021.
//

import Foundation

struct User: Codable, Hashable {
    let login: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let followers: Int
    let following: Int
    let createdAt: Date
}
