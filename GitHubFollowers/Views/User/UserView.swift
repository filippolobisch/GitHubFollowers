import SwiftUI
import SwiftData

struct UserView: View {
    var username: String
    @Binding var previousUsername: String
    @State var user: User = .placeholder
    @State private var isShowingUserFollowers = false
    @State private var isShowingUserProfile = false
    
    @Query private var favourites: [Favourite]
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            UserHeaderView(user: user)
            
            Spacer(minLength: 20)
            
            UserProfileInfoCell(user: user, isShowingUserProfile: $isShowingUserProfile)
                .withUserInfoPadding()
            
            Spacer(minLength: 20)
            
            UserFollowersInfoCell(user: user, isShowingUserFollowers: $isShowingUserFollowers)
                .withUserInfoPadding()
            
            Text("GitHub user since \(user.createdAt.convertToMonthYearFormat())")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 20)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .task {
            await getUserInfo()
        }
        .onChange(of: isShowingUserFollowers) { _, newValue in
            if previousUsername != username {
                previousUsername = username
            }
            
            dismiss()
        }
        .fullScreenCover(isPresented: $isShowingUserProfile) {
            SafariView(url: URL(string: user.htmlUrl)!)
                .ignoresSafeArea()
        }
    }
    
    private func getUserInfo() async {
        do {
            user = try await NetworkManager.shared.getUserInfo(for: username)
        } catch {
            print(error)
        }
    }
}

#Preview {
    UserView(username: "filippolobisch", previousUsername: .constant("DiogoJGoncalves"))
}
