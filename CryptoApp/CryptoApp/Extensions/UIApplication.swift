//
//  UIApplication.swift
//  CryptoApp
//
//  Created by Ref on 13/08/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
