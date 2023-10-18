import SwiftUI
import SwiftData

struct FollowersListView: View {
    @State var username: String
    @State private var viewModel = FollowerListViewModel()
    @State private var searchText = ""
    
    private var filteredFollowers: [Follower] {
        guard !searchText.isEmpty else { return viewModel.followers }
        
        return viewModel.followers.filter { follower in
            follower.login.lowercased().contains(searchText.lowercased())
        }
    }
    
    @Query private var favourites: [Favourite]
    @Environment(\.modelContext) private var modelContext
    
    var isFavourite: Bool {
        favourites.contains(where: { $0.username == username })
    }
    
    private let columns: [GridItem] = [
        .init(.flexible()),
        .init(.flexible()),
        .init(.flexible())
    ]
    
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(filteredFollowers, id: \.id) { follower in
                    FollowerView(follower: follower)
                        .onTapGesture {
                            viewModel.selectedFollower = follower.login
                        }
                }
            }
            
            if viewModel.hasMoreFollowers {
                Button {
                    viewModel.loadMoreFollowers(username: username)
                } label: {
                    Label("Load more followers", systemImage: "person.badge.plus")
                }
            }
        }
        .task {
            await viewModel.getFollowers(username: username)
        }
        .searchable(text: $searchText, prompt: Text("Search for a username"))
        .navigationTitle(username)
        .sheet(isPresented: $viewModel.isDetailViewPresented) {
            NavigationStack {
                UserView(username: viewModel.selectedFollower)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    viewModel.selectedFollower = username
                } label: {
                    Label("View Profile", systemImage: "person.circle.fill")
                }
            }
        }
        .overlay {
            if filteredFollowers.isEmpty {
                ContentUnavailableView(label: {
                    Image(.emptyStateLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text("No Followers")
                        .bold()
                }, description: {
                    Text("This user doesn't have any followers. Go follow them.")
                })
            }
        }
    }
}

#Preview {
    NavigationStack {
        FollowersListView(username: "iDylanK")
    }
}
