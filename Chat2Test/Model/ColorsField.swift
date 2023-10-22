//
//  ColorsField.swift
//  Chat2Test
//
//  Created by Have Dope on 03.05.2023.
//

import Foundation
import SwiftUI

class ColorsField {
    
    var colorName = ""
    
    
    func colorField(casesting: String) -> Color {
        if casesting == "blackF"{
            colorName = "blackF"
        }else if casesting == "GreenF" {
            colorName = "GreenF"
        }
        return Color(colorName)
            
    }
}
