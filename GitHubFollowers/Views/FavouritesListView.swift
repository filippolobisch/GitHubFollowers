//
//  FavouritesListView.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 15.07.23.
//

import SwiftUI

struct FavouritesListView: View {
    @State private var viewModel = FavouritesViewModel()
    @State private var isRetrieveFavouritesAlertPresented = false
    @State private var isDeleteAlertPresented = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.favourites) { favourite in
                FavouriteView(favourite: favourite)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            let result = viewModel.remove(favourite: favourite)
                            if result == false {
                                isDeleteAlertPresented = true
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                                .tint(.red)
                        }

                    }
            }
            .navigationTitle("Favourites")
//            .task {
//                do {
//                    try viewModel.retrieveFavourites()
//                } catch {
//                    isRetrieveFavouritesAlertPresented = true
//                }
//            }
            .alert("Unable to retrieve favourited users.", isPresented: $isRetrieveFavouritesAlertPresented) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("An error was thrown retrieving favourited users, specifically in the decoding process.")
            }
            .alert("Unable to delete User.", isPresented: $isDeleteAlertPresented) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("An error occurred when removing a favourited user.")
            }

        }
    }
}

#Preview {
    FavouritesListView()
}
