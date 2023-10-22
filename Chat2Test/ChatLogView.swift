//
//  ChatLogView.swift
//  Chat2Test
//
//  Created by Have Dope on 27.05.2023.
//

import SwiftUI
import Firebase

struct FCon {
    static let fromId = "fromId"
    static let toID = "toID"
    static let text = "text"
    static let timestamp = "timestamp"
    static let recentMessage = "recent_messages"
    static let messages = "messages"
    static let profileImageUrl = "profileImageUrl"
    static let email = "email"
}

class ChatLogViewModel: ObservableObject{
    
    @Published var chatText = ""
    @Published var chatMessasges = [ChatMessage]()
    var chatUser: ChatUser?
    
    
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        fetchMessage()
    }
    
    var firestoreListener: ListenerRegistration?
    
     func fetchMessage() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
         firestoreListener?.remove()
         self.chatMessasges.removeAll()
         firestoreListener =  FirebaseManager.shared.firestore
            .collection(FCon.messages)
            .document(fromId)
            .collection(toId)
            .order(by: FCon.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("-----.....>>>>>Failed to listen for messages: \(error)")
                    
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessasges.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    
    
    
    
    func handleSend(){
        print(chatText)
        guard let  fromId  = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toID = chatUser?.uid else {return}
        
        let document = FirebaseManager.shared.firestore.collection(FCon.messages).document(fromId)
            .collection(toID)
            .document()
        
        let messageData = [FCon.fromId: fromId,
                           FCon.toID: toID,
                           FCon.text: self.chatText,
                           FCon.timestamp: Timestamp()
        ] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print("Не получилось добавить в базу сообщение --->>> \( error.localizedDescription) ")
                return
            }
            print("Смогли доавбить")
            self.persistRecentMessage()
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection(FCon.messages).document(toID)
            .collection(fromId)
            .document()
        
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print("Не получилось добавить в базу сообщение --->>> \( error.localizedDescription) ")
                return
            }
            print("Смогли доавбить 2")
        }
    }
    
    private func persistRecentMessage(){
        guard let chatUser = chatUser else {return}
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = self.chatUser?.uid else {return}
        
       let document =  FirebaseManager.shared.firestore
            .collection(FCon.recentMessage)
            .document(uid)
            .collection(FCon.messages)
            .document(toId)
        
        let data = [FCon.timestamp : Timestamp(),
                    FCon.text:self.chatText,
                    FCon.fromId: uid,
                    FCon.toID: toId,
                    FCon.profileImageUrl: chatUser.profileImageUrl ,
                    FCon.email: chatUser.email
        ] as [String : Any]
        
        document.setData(data) { error in
            if let error = error{
                print("НЕ удалось сохранить недавнее сообщение \(error)")
                return
                                
            }
        }
    }

    @Published var count = 0
}


struct ChatLogView: View {

    @ObservedObject var vm: ChatLogViewModel
    
    
    var body: some View {
        ZStack {
            messagesView
            VStack(spacing: 0) {
                Spacer()
                chatBottomBar
                    .background(Color.white.ignoresSafeArea())
            }
        }
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear{
            vm.firestoreListener?.remove()
            
        }
        
    }
    
    private var messagesView: some View {
        
        ScrollView {
            
            ScrollViewReader{ ScrollViewProxy in
                VStack{
                    ForEach(vm.chatMessasges) { message in
                        MessageView(message: message)
                    }
                    HStack{ Spacer() } .frame(height: 24)
                        .id("Empty")
                }.onReceive(vm.$count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        ScrollViewProxy.scrollTo("Empty", anchor: .bottom)

                    }
                }
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom) {
            chatBottomBar
                .background(Color(.systemBackground))
                .ignoresSafeArea()
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            
            Button {
                if !vm.chatText.isEmpty ||  vm.chatText != " "{
                    vm.handleSend()
                }
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


struct MessageView: View {
    
    let message: ChatMessage
    var body: some View{
        VStack{
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(20)
                }
            }else{
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(820)
                    Spacer()
                }
            }
        }  .padding(.horizontal)
            .padding(.top, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}
struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            //            ChatLogView(chatUser: .init(data: ["uid" : "DLR0ZSbLlnhFnV0toV1J78kGtK73","email":"test2@mail.ru"]))
            
            MainMessagesView()
        }
    }
}
