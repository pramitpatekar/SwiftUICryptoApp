//
//  Date.swift
//  CryptoApp
//
//  Created by Ref on 21/08/24.
//

import Foundation

extension Date {
    
    init(coinGeckoString: String) {                 // custom initializer
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)     // regular initializer with a specific date
        
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
        
    }
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
    
}

