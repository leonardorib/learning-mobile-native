//
//  ChatUser.swift
//  realtimechat
//
//  Created by Leonardo Ribeiro on 3/5/23.
//

import Foundation

struct ChatUser: Identifiable {
    var id: String { uid }
    var username: String { email.components(separatedBy: "@")[0] }
    
    let uid, email, imageProfileUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.imageProfileUrl = data["imageProfileUrl"] as? String ?? ""
    }
}
