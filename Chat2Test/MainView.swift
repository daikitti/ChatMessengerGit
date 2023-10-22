//
//  MainView.swift
//  Chat2Test
//
//  Created by Have Dope on 29.04.2023.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAppCheckInterop
struct MainView: View {

    var body: some View {
        VStack{
            
            LiquidAnimation()
        }
    }
}


struct LiquidAnimation: View {
    @State var offset: CGSize = .zero
    @State var showHome = false
    var body: some View {
        ZStack {
            Image("257").resizable()
                .overlay(
                    VStack(alignment: .leading, spacing: 20, content: {
                        Text("Messeger")
                            .font(.system(size: 38, weight: .bold))
                            .fontWeight(.heavy)
                            .shadow(color: .gray, radius: 7, x: 2, y: 2 )
                        Text("Привет, меня зовут Никита и это месседжер для моих самых близких друзей. ")
                            .font(.system(.headline))
                            .fontWeight(.light)
                            .shadow(color: .black,radius: 24, x: 2, y: 2 )
                        
                        
                        
                        Spacer()
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 170)
                    .offset(x: -15)
                    
                )
                .clipShape(LiquidSwipe(offset: offset))
                .ignoresSafeArea()
                .overlay(
                    
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
                        .frame(width: 40, height: 30)
                        .contentShape(Rectangle())
                        .gesture(DragGesture().onChanged({ (value) in
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)) {
                                offset = value.translation
                            }
                        }).onEnded({ (value) in
                            
                            let screen = UIScreen.main.bounds
                            
                            withAnimation(.spring()){
                                if -offset.width > screen.width / 2 {
                                    offset.width = -screen.height
                                    showHome.toggle()
                                } else {
                                    offset = .zero
                                }
                            }
                            
                        }))
                        .offset(x: 15, y:58)
                        .opacity(offset == .zero ? 1: 0)
                    
                    ,alignment: .topTrailing
                    
                )
                .padding(.trailing)
            
            if showHome{
                InfoView()
                //                                                    .onTapGesture {
                //                                                        withAnimation(.spring()){
                //                                                            offset = .zero
                //                                                            showHome.toggle()
                //                                                        }}
                
            }
        }.animation(.easeIn(duration: 0.7), value: showHome)
    }
}
// MARK: - SHAPE
struct LiquidSwipe: Shape {
    // MARK: - GET OFFSET VALUE
    var offset: CGSize
    // MARK: - PATH ANIMATION
    var animatableData: CGSize.AnimatableData{
        get{return offset.animatableData}
        set{offset.animatableData = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            // MARK: - FROM
            let from = 80 + (offset.width)
            path.move(to: CGPoint(x: rect.width, y: from > 80 ? 80 : from))
            
            // MAR: - TO
            var to = 180 + (offset.height) + (-offset.width)
            to = to < 180 ? 180 : to
            
            let mid : CGFloat = 80 + ((to - 80) / 2)
            
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - 50, y: mid), control2: CGPoint(x: width - 50, y: mid))
        }
    }
}


struct InfoView: View{
    

    
    @State var email = ""
    @State var password = ""
    @State var rePasswordField = ""
    @State var errorMessage = ""
    @State var nextView = false
    @State var shouldShowImagePicker = false
    
    @State var isAuthinfo = false
    @State var isShowAlertMessage = false
    @State var isLoginMode: Bool = true
    @State var passCorrect: Bool?
    
    let passValid = ChekFieldPass.shered.isPasswordValid
    let emaeilValid = ChekFieldPass.shered.isEmailValid
    
    
    var body: some View{
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack{
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 164  , height: 164)
                                        .cornerRadius(164)
                                        .shadow(color: Color(.label),radius: 15)
                                }else{
                                    
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(redColor)
                                }
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 82)
                                    .stroke(Color(.label), lineWidth: 2)
                            }
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .cornerRadius(20)
                    .background(Color.clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.label), lineWidth: 2)
                    }
                    HStack{Spacer()}
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Войти" : "Создать")
                                
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .font(.system(size: 14, weight: .semibold))
                                
                            Spacer()
                        }.background(LinearGradient(colors: [ .mint, .black], startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(50)
                            .frame(width: 173)
                            .shadow(radius: 10)
                    }
                    Spacer()
                    Text(errorMessage).foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Авторизация" : "Создать аккаунт")
            .background(Color(.init(white: 0, alpha: 0.0))
                .ignoresSafeArea())
        }.fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil, content: {
            ImagePicker(image: $image)
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $nextView) {
            MainMessagesView()
        }
    }
    
    @State var image: UIImage?
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
            print("log into Firebase ")
        } else {
            createNewAccaunt()
            print("Register")
        }
    }
    
    private func loginUser(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let err = error {
                print("не удалось войти :", err.localizedDescription)
                errorMessage = "не удалось войти : \( err.localizedDescription)"
                return
            }
            FirebaseManager.shared.auth.currentUser?.sendEmailVerification(completion: { error in
                if let err = error{
                    
                    errorMessage = "ОШИБКА ВЕРИФИКАЦИИ  \(err.localizedDescription)"
                    return

                }
            })
            nextView.toggle()
            errorMessage = "Успешно вошли под пользователем\(result?.user.email ?? "")"
        }
    }
    
    private func createNewAccaunt(){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            
            if let err = error{
                print("не получилось создать нового пользователя: ", err)
                self.errorMessage = "Не получилось создать пользователя: \(err.localizedDescription)"
                return
            }else{
                print("Регистрация прошла успешно: ", result?.user.email ?? "" )
                self.persistImagetoStorage()
            }
        }
    }
    @State var redColor = Color(.label)
    private func persistImagetoStorage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        if image == nil{
            self.redColor = Color.red
            return
        }
        
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {return}

        
        ref.putData(imageData, metadata: nil ) { metadata, error in
            if let err = error {
                self.errorMessage = "НЕ получилось загрузить картинку: \(err)"
                return
            }
            ref.downloadURL { url, error  in
                if let err = error {
                    self.errorMessage = "НЕ получилось загрузить картинку: \(err)"
                    return
                }
                self.errorMessage =  "Получилось загрузить картинку: \(url!)"
            print(url ?? "тут должны быть ссылка ")
            
                guard let url = url else {return}
                storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let userData = ["email": email,
                        "password": password,
                        "uid": uid,
                        "profileImageUrl": imageProfileUrl.absoluteString ]
        
        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .setData(userData) { error in
                
                if let err = error{
                    errorMessage = "Не получилось добавить в базу: \(err.localizedDescription)"
                 return
                }
                print("Succes   ")

        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
