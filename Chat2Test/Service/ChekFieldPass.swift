//
//  ChekFieldPass.swift
//  Chat2Test
//
//  Created by Have Dope on 02.05.2023.
//

import Foundation



class ChekFieldPass {
    
    static let shered = ChekFieldPass()
    init() {}
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        
        return passwordTest.evaluate(with: password)
        
    }
    func isEmailValid(_ email : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[@]).{3,}$")
        
        return passwordTest.evaluate(with: email)
        
    }
    
    
}
