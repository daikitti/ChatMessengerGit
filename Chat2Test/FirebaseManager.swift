//
//  LoginView.swift
//  Chat2Test
//
//  Created by Have Dope on 26.05.2023.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAppCheckInterop

class FirebaseManager: NSObject{
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    var currentUser: ChatUser?

    static let shared = FirebaseManager()
    
    override init() {
       
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
