import Foundation
import SwiftData

@Model
class Favourite: Identifiable {
    var id: String { username }
    
    var username: String
    var avatarURL: String
    
    init(username: String, avatarURL: String) {
        self.username = username
        self.avatarURL = avatarURL
    }
}
