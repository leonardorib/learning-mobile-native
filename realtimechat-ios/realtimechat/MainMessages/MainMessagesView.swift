//
//  MainMessagesView.swift
//  realtimechat
//
//  Created by Leonardo Ribeiro on 3/5/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatUser {
    let uid, email, imageProfileUrl: String
}

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    init() {
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
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
                let email = data["email"] as? String ?? ""
                let imageProfileUrl = data["imageProfileUrl"] as? String ?? ""
                self.chatUser = ChatUser(uid: uid, email: email, imageProfileUrl: imageProfileUrl)
            }
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
                var username = vm.chatUser?.email ?? ""
                Text(username.components(separatedBy: "@")[0])
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
                            print("Handle sign out")
                        }),
                        .cancel()
                    ])
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
    
    private var newMessageButton: some View {
        Button {
            
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
