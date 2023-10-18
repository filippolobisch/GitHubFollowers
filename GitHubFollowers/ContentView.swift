import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
            FavouritesListView()
                .tabItem { Label("Favourites", systemImage: "heart.circle.fill") }
        }
    }
}

#Preview {
    ContentView()
}
