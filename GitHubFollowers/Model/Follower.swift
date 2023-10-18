import Foundation

struct Follower: Codable, Hashable, Identifiable {
    var id: String { login }
    
    let login: String
    let avatarUrl: String
    
    
    static var placeholder: Follower {
        Follower(login: "Placeholder", avatarUrl: "placeholder")
    }
}
