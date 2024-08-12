//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by Ref on 11/08/24.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []                 //by using @Published we can make it a Publisher and then we can Subscribe to it and whenever its value changes then it publishes that value and then all the subscribers receive that data
    
//    var cancellables = Set<AnyCancellable>()
    
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()             //optional but its better to do this
            })

    }
    
}
