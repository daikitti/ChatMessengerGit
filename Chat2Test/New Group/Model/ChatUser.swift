//
//  ChatUser.swift
//  Chat2Test
//
//  Created by Have Dope on 26.05.2023.
//
import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
}
