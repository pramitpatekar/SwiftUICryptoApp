//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by Ref on 20/08/24.
//



import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetailModel? = nil
    
    //by using @Published we can make it a Publisher and then we can Subscribe to it and whenever its value changes then it publishes that value and then all the subscribers receive that data
    
//    var cancellables = Set<AnyCancellable>()
    
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else { return }
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetails) in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()             //optional but its better to do this
            })

    }
    
}
