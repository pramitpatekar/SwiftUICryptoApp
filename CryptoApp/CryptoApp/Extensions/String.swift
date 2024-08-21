//
//  String.swift
//  CryptoApp
//
//  Created by Ref on 21/08/24.
//

import Foundation

extension String {
    
    // "<[^>]+>" this string is used to find the HTML in the string
    
    var removingHTMLOccurrences: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)     //extension to get rid of the HTML in our string
    }
}
