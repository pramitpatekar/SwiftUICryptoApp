//
//  StatisticsModel.swift
//  CryptoApp
//
//  Created by Ref on 14/08/24.
//

import Foundation


struct StatisticsModel: Identifiable {
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
                                                                 //default value
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
}

//let newModel = StatisticsModel(title: "", value: "", percentageChange: 1)
//let newModel2 = StatisticsModel(title: "", value: "")
