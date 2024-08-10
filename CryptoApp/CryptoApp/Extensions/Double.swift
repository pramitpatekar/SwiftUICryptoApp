//
//  Double.swift
//  CryptoApp
//
//  Created by Ref on 09/08/24.
//

import Foundation

extension Double {
    
    ///Converts a Double into a Currency with 2 decimal places
    ///```
    ///Convert 1234.56 to $1,234.56
    ///```
    
    //The above statement is used to add this information into the information of the variable that we created
    
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current               //Default currency Value
//        formatter.currencyCode = "usd"            //used to change the currency (override)
//        formatter.currencySymbol = "$"            //used to change the currency symbol (override)
        
        formatter.minimumFractionDigits = 2         //depending on the number this will format between 2 and 6 decimal places
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    
    
    ///Converts a Double into a Currency as a string with 2 decimal places
    ///```
    ///Convert 1234.56 to "$1,234.56"
    ///```
    
    
    func asCurrencywith2Decimals() -> String {
        let number = NSNumber(value: self)            // self is the current value which would be double and on which we are applying this function
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    
    
    
    
    
    
    ///Converts a Double into a Currency with 2-6 decimal places
    ///```
    ///Convert 1234.56 to $1,234.56
    ///Convert 12.3456 to $12.3456
    ///Convert 0.123456 to $0.123456
    ///```
    
    //The above statement is used to add this information into the information of the variable that we created
    
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current               //Default currency Value
//        formatter.currencyCode = "usd"            //used to change the currency (override)
//        formatter.currencySymbol = "$"            //used to change the currency symbol (override)
        
        formatter.minimumFractionDigits = 2         //depending on the number this will format between 2 and 6 decimal places
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    
    ///Converts a Double into a Currency as a string with 2-6 decimal places
    ///```
    ///Convert 1234.56 to "$1,234.56"
    ///Convert 12.3456 to "$12.3456"
    ///Convert 0.123456 to "$0.123456"
    ///```

    
    
    func asCurrencywith6Decimals() -> String {
        let number = NSNumber(value: self)            // self is the current value which would be double and on which we are applying this function
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    
    ///Converts a Double into a string representation with 2 decimal places
    ///```
    ///Convert 1.2345 to "1.23"
    ///```
    
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    
    ///Converts a Double into a string representation with 2 decimal places
    ///```
    ///Convert 1.2345 to "1.23%"
    ///```
    
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
}
