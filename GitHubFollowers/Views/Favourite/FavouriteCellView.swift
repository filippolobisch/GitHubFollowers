import SwiftUI

struct FavouriteCell: View {
    let favourite: Favourite
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: favourite.avatarURL)) { image in
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
            
            Text(favourite.username)
                .font(.title2)
                .bold()
                .minimumScaleFactor(0.9)
                .truncationMode(.tail)
        }
    }
}

#Preview {
    FavouriteCell(favourite: .init(username: "filippolobisch", avatarURL: ""))
}
