//
//  ChatMessage.swift
//  Chat2Test
//
//  Created by Have Dope on 31.05.2023.
//

import Foundation

struct ChatMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FCon.fromId] as? String ?? ""
        self.toId = data[FCon.toID ] as? String ?? ""
        self.text = data[FCon.text] as? String ?? ""
    }
}
