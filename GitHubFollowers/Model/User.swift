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
    
    static var placeholder: User {
        User(login: "placeholder", avatarUrl: "", name: "Placeholder User", location: nil, bio: "This is a placeholder user bio.", publicRepos: 0, publicGists: 0, htmlUrl: "", followers: 0, following: 0, createdAt: Date())
    }
}
