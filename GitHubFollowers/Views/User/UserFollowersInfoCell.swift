import SwiftUI

struct UserFollowersInfoCell: UserInfoViewProtocol {
    var user: User
    @Binding var isShowingUserFollowers: Bool
    
    var body: some View {
        VStack {
            HStack {
                GFItemInfoView(infoType: .followers, count: user.followers)
                Spacer()
                GFItemInfoView(infoType: .following, count: user.following)
            }
            
            Button(action: {
                isShowingUserFollowers = true
            }, label: {
                Label("Get Followers", systemImage: "person.3.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44)
            })
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .padding(.top, 16)
        }
    }
}
