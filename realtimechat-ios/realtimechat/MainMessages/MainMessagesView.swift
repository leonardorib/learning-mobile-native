//
//  MainMessagesView.swift
//  realtimechat
//
//  Created by Leonardo Ribeiro on 3/5/23.
//

import SwiftUI
import SDWebImageSwiftUI

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth
            .currentUser?.uid
            else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        self.errorMessage = "\(uid)"
        FirebaseManager.shared.firestore.collection("users")
            .document(uid)
            .getDocument {
                snapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch current user, \(error)"
                    return
                }
                
                guard let data = snapshot?.data() else { return }
                
                self.chatUser = .init(data: data)
            }
    }
    
    @Published var isUserCurrentlyLoggedOut = false
    
    func handleSignOut() {
        self.isUserCurrentlyLoggedOut = true
        try? FirebaseManager.shared.auth.signOut()
    }
}


struct MainMessagesView: View {
    @State var shouldShowLogoutOptions = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                customNavbar
                messagesView
            }
            .overlay(
                newMessageButton,
                alignment: .bottom
            )
            .navigationBarHidden(true)
        }
    }
    
    private var customNavbar: some View {
        HStack(spacing: 16) {
            WebImage(url: URL(string: vm.chatUser?.imageProfileUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipped()
                .cornerRadius(32)
                .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color(.label), lineWidth: 1))
                .shadow(radius: 5)

            VStack (alignment: .leading, spacing: 4) {
                Text(vm.chatUser?.username ?? "")
                    .font(.system(size: 16, weight: .bold))
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            Button {
                shouldShowLogoutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
                
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogoutOptions) {
            .init(title: Text("Settings"), message:
                    Text("What do you want to do?"), buttons: [
                        .destructive(Text("Sign Out"), action: {
                            vm.handleSignOut()
                        }),
                        .cancel()
                    ])
        }.fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginAndRegisterView(didCompleteLoginProgress: {
                self.vm.fetchCurrentUser()
                self.vm.isUserCurrentlyLoggedOut = false
            })
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) {
                num in
                VStack {
                    HStack (spacing: 16){
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color(.label), lineWidth: 1))
                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
            }.padding(.bottom, 50)
        }
    }
    
    @State var shouldShowNewMessageScreen = false
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
                
        }.fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            CreateNewMessageView()
        }
    }
    
   
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
        MainMessagesView()
    }
}
