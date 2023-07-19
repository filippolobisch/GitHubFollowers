//
//  FavouriteView.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 15.07.23.
//

import SwiftUI

struct FavouriteView: View {
    let favourite: Follower
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: favourite.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(.avatarPlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: 60, height: 60)
            
            Text(favourite.login)
                .font(.title2)
                .bold()
                .minimumScaleFactor(0.9)
                .truncationMode(.tail)
        }
    }
}

#Preview {
    FavouriteView(favourite: .init(login: "filippolobisch", avatarUrl: ""))
}
