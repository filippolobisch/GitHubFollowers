import SwiftUI

struct UserProfileInfoCell: UserInfoViewProtocol {
    var user: User
    @Binding var isShowingUserProfile: Bool
    
    var body: some View {
        VStack {
            HStack {
                GFItemInfoView(infoType: .repos, count: user.publicRepos)
                Spacer()
                GFItemInfoView(infoType: .gists, count: user.publicGists)
            }
            
            Button(action: {
                isShowingUserProfile = true
            }, label: {
                Label("GitHub Profile", systemImage: "person.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44)
            })
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .padding(.top, 16)
        }
    }
}
