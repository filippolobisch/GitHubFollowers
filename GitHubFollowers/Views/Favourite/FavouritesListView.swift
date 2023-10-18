import SwiftUI
import SwiftData

struct FavouritesListView: View {
    @Query private var favourites: [Favourite]
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
    @State private var isDeleteAlertPresented = false
    
    var filteredFavourites: [Favourite] {
        guard !searchText.isEmpty else { return favourites }
        
        return favourites.filter { favourite in
            favourite.username.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredFavourites) { favourite in
                    NavigationLink(value: favourite) {
                        FavouriteCell(favourite: favourite)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        removeFromFavourites(for: filteredFavourites[index])
                    }
                }
            }
            .navigationTitle("Favourites")
            .navigationDestination(for: Favourite.self) { favourite in
                UserView(username: favourite.username)
            }
            .searchable(text: $searchText)
            .alert("Unable to unfavourite a User.", isPresented: $isDeleteAlertPresented) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("An error occurred when removing a favourited user.")
            }
            .overlay {
                if filteredFavourites.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Favourites", systemImage: "heart.circle.fill")
                    }, description: {
                        Text("You currently have no favourites. Start adding them to see the list.")
                    })
                }
            }
        }
    }
    
    private func removeFromFavourites(for favourite: Favourite) {
        do {
            try withAnimation {
                modelContext.delete(favourite)
                try modelContext.save()
            }
        } catch {
            isDeleteAlertPresented = true
        }
    }
}

#Preview {
    FavouritesListView()
}
