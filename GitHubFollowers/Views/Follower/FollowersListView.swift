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
    
    @State private var isNotAbleToRetrieveUserInfoPresented = false
    
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
                        .contextMenu {
                            favouriteButton(for: follower.login)
                            viewProfileButton(for: follower.login)
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
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isDetailViewPresented) {
            NavigationStack {
                UserView(username: viewModel.selectedFollower, previousUsername: $username)
            }
        }
        .onChange(of: username) { _, _ in
            resetUI()
        }
        .toolbar {
            ToolbarTitleMenu {
                favouriteButton(for: username)
                viewProfileButton(for: username)
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
        .alert("Unable to retrieve user", isPresented: $isNotAbleToRetrieveUserInfoPresented) {
            Button("OK", role: .cancel) {
                isNotAbleToRetrieveUserInfoPresented = false
            }
        } message: {
            Text("The user you are trying to favourite/unfavourite could not be retrieved.")
        }
    }
    
    private func resetUI() {
        viewModel = FollowerListViewModel()
        Task {
            await viewModel.getFollowers(username: username)
        }
    }
    
    @ViewBuilder
    private func favouriteButton(for username: String) -> some View {
        Button {
            Task {
                if isFavourite(username: username) {
                    await removeFromFavourites(user: username)
                } else {
                    await favourite(user: username)
                }
            }
        } label: {
            if isFavourite(username: username) {
                Label("Remove from favourites", systemImage: "heart.slash.fill")
            } else {
                Label("Add to favourites", systemImage: "heart")
            }
        }
    }
    
    @ViewBuilder
    private func viewProfileButton(for username: String) -> some View {
        Button {
            viewModel.selectedFollower = username
        } label: {
            Label("View Profile", systemImage: "person.circle.fill")
        }
    }
    
    private func isFavourite(username: String) -> Bool {
        favourites.contains(where: { $0.username.lowercased() == username.lowercased() })
    }
    
    private func getUserAsFavourite(for username: String) async -> Favourite? {
        guard let user =  try? await NetworkManager.shared.getUserInfo(for: username) else { return nil }
        return Favourite(username: user.login, avatarURL: user.avatarUrl)
    }
    
    private func favourite(user username: String) async {
        guard let favourite = await getUserAsFavourite(for: username) else {
            isNotAbleToRetrieveUserInfoPresented = true
            return
        }
        
        withAnimation {
            modelContext.insert(favourite)
        }
    }
    
    private func removeFromFavourites(user username: String) async {
        guard let favourite = favourites.first(where: { $0.username.lowercased() == username.lowercased() }) else {
            isNotAbleToRetrieveUserInfoPresented = true
            return
        }
        
        withAnimation {
            modelContext.delete(favourite)
        }
    }
}

#Preview {
    NavigationStack {
        FollowersListView(username: "filippolobisch")
    }
}
