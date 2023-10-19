import SwiftUI

struct GFItemInfoView: View {
    var imageName: String
    var title: String
    var count: Int
    
    init(imageName: String, title: String, count: Int) {
        self.imageName = imageName
        self.title = title
        self.count = count
    }
    
    init(infoType: ItemInfoType, count: Int) {
        switch infoType {
        case .repos:
            self.init(imageName: "folder", title: "Public Repos", count: count)
        case .gists:
            self.init(imageName: "text.alignleft", title: "Public Gists", count: count)
        case .following:
            self.init(imageName: "person.2", title: "Following", count: count)
        case .followers:
            self.init(imageName: "heart", title: "Followers", count: count)
        }
    }
    
    var body: some View {
        VStack {
            Label(title, systemImage: imageName)
                .font(.system(size: 18, weight: .bold))
                .minimumScaleFactor(0.9)
                .truncationMode(.tail)
                .frame(height: 18, alignment: .center)
            
            Text(String(count))
                .font(.system(size: 18, weight: .bold))
                .minimumScaleFactor(0.9)
                .truncationMode(.tail)
                .frame(height: 18)
        }
    }
}

enum ItemInfoType {
    case repos
    case gists
    case following
    case followers
}

#Preview {
    GFItemInfoView(imageName: "heart.fill", title: "Test", count: 4)
}
