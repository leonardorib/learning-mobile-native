//
//  ChatLogView.swift
//  realtimechat
//
//  Created by Leonardo Ribeiro on 3/9/23.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser: ChatUser?
    
    @State var chatText = ""
    
    var body: some View {
        VStack {
            messagesView
            chatBottomBar
        }
        .navigationTitle(chatUser?.username ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10) {num in
                HStack {
                    Spacer()
                    HStack {
                        Text("FAKE MESSAGE FOR NOW")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
               
            }
            HStack{
                Spacer()
            }
        }
        .background(Color(.systemFill))
    }
    
    private var chatBottomBar: some View {
        HStack (spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.label))

            
            TextEditor(text: $chatText)
                .frame(height: 50)
                .cornerRadius(10)
                .shadow(color: Color(.label), radius: 1.0)

            Button {
                
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatLogView(chatUser: .init(data: [
                "uid": "Qx05py736DZzuI90pLEMU4CNVB02",
                "email": "leonardo.rib@hotmail.com",
                "imageProfileUrl": "https://firebasestorage.googleapis.com:443/v0/b/chat-app---learning-native.appspot.com/o/Qx05py736DZzuI90pLEMU4CNVB02?alt=media&token=aff07b34-6f74-407d-b6c8-a513de47ada3"
            ]))
        }
    }
}
