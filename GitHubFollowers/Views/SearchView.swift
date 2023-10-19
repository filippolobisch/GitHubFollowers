import SwiftUI

struct SearchView: View {
    @State private var username = ""
    @State private var showFollowers = false
    @State private var showsEmptyUsernameAlert = false
    @FocusState private var isUsernameTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(.ghLogo)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        isUsernameTextFieldFocused = false
                    }
                
                TextField("Enter a username", text: $username)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .keyboardType(.webSearch)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .focused($isUsernameTextFieldFocused)
                    .frame(maxWidth: .infinity, idealHeight: 50, alignment: .center)
                    .padding(.top, 48)
                
                Button(action: {
                    guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
                        showsEmptyUsernameAlert = true
                        return
                    }
                    
                    showFollowers = true
                    isUsernameTextFieldFocused = false
                }, label: {
                    Label("Get Followers", systemImage: "person.3.fill")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 50, idealHeight: 50)
                })
                .tint(.green)
                .buttonStyle(.borderedProminent)
                .padding(.top, 100)
                .padding(.bottom, 50)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding([.leading, .trailing], 50)
            .navigationDestination(isPresented: $showFollowers) {
                FollowersListView(username: username)
            }
            .alert("Empty Username", isPresented: $showsEmptyUsernameAlert) {
                Button("OK", role: .cancel) { 
                    showsEmptyUsernameAlert = false
                }
            } message: {
                Text("Please enter a username. We need to know who to look for.")
            }

        }
    }
}

#Preview {
    SearchView()
}
