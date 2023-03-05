//
//  FirebaseManager.swift
//  realtimechat
//
//  Created by Leonardo Ribeiro on 3/5/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()
    override init() {
        
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}