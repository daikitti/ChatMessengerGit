//
//  Chat2TestApp.swift
//  Chat2Test
//
//  Created by Have Dope on 29.04.2023.
//

import SwiftUI
import FirebaseCore


let screen = UIScreen.main.bounds
let userDefault = UserDefaults.standard

let isLogin = userDefault.object(forKey: "isLogin") as? Bool ?? false

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}



@main
struct Chat2TestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
        }
    }
}

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}
