import Foundation
import Observation

@Observable
class FollowerListViewModel {
    var followers: [Follower] = []
    var hasMoreFollowers = true
    var isDetailViewPresented: Bool = false
    
    private var page = 1
    
    var selectedFollower: String = "" {
        didSet {
            isDetailViewPresented = true
        }
    }
    
    
    func getFollowers(username: String) async {
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
    
    func loadMoreFollowers(username: String) {
        guard hasMoreFollowers else { return }
        page += 1
        
        Task {
            await getFollowers(username: username)
        }
    }
}
