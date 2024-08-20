//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Ref on 20/08/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { (returnedCoinDetails) in
                print("Received Coin Detail Data")
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
    }
    
}
