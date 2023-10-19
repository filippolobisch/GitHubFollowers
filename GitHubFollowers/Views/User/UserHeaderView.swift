import Foundation
import SwiftUI

struct UserHeaderView: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 16) {
                AsyncImage(url: URL(string: user.avatarUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image("avatar-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 90, height: 90)
                
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(user.login)
                        .font(.system(size: 34, weight: .bold))
                        .minimumScaleFactor(0.9)
                        .truncationMode(.tail)
                        .frame(height: 38)
                    
                    if let name = user.name {
                        Text(name)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.secondary)
                            .minimumScaleFactor(0.9)
                            .truncationMode(.tail)
                            .frame(height: 20)
                    }
                    
                    Label(user.location ?? "No location", systemImage: "mappin.and.ellipse")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.secondary)
                        .minimumScaleFactor(0.9)
                        .truncationMode(.tail)
                        .frame(height: 20)
                }
            }
        
            Text(user.bio ?? "No bio available.")
                .font(.body)
                .foregroundStyle(.secondary)
                .minimumScaleFactor(0.75)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

#Preview {
    UserView(username: "filippolobisch", previousUsername: .constant("DiogoJGoncalves"))
}
