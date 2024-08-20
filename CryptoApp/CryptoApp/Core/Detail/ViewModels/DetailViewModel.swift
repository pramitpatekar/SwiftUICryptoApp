//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Ref on 20/08/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticsModel] = []
    @Published var additionalStatistics: [StatisticsModel] = []
    
    
    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
    }
    
    
    private func mapDataToStatistics(CoinDetailModel: CoinDetailModel?, CoinModel: CoinModel) -> (overview: [StatisticsModel], additional: [StatisticsModel] ) {
        
        let overviewArray = createOverviewArray(CoinModel: CoinModel)
        
        let additionalArray = createAdditionalArray(CoinDetailModel: CoinDetailModel, CoinModel: CoinModel)
        
        return(overviewArray, additionalArray)
        
    }
    
    
    private func createOverviewArray(CoinModel: CoinModel) -> [StatisticsModel] {
        // overview
        let price = CoinModel.currentPrice.asCurrencywith6Decimals()
        let pricePercentChange = CoinModel.priceChangePercentage24H
        let priceStat = StatisticsModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (CoinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = CoinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticsModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(CoinModel.rank)"
        let rankStat = StatisticsModel(title: "Rank", value: rank)
        
        let volume = "$" + (CoinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticsModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticsModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        
        return overviewArray
    }
    
    
    private func createAdditionalArray(CoinDetailModel: CoinDetailModel?, CoinModel: CoinModel) -> [StatisticsModel] {
        
        //additional
        let high = CoinModel.high24H?.asCurrencywith6Decimals() ?? "N/A"
        let highStat = StatisticsModel(title: "24H High", value: high)
        
        let low = CoinModel.low24H?.asCurrencywith6Decimals() ?? "N/A"
        let lowStat = StatisticsModel(title: "24H Low", value: low)
        
        let priceChange = CoinModel.priceChange24H?.asCurrencywith6Decimals() ?? "N/A"
        let pricePercentChange = CoinModel.priceChangePercentage24H
        let priceChangeStat = StatisticsModel(title: "24H Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (CoinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = CoinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticsModel(title: "24H Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = CoinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockStat = StatisticsModel(title: "Block Time", value: blockTimeString)
        
        let hashing = CoinDetailModel?.hashingAlgorithm ?? "N/A"
        let hashingStat = StatisticsModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticsModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        
        return additionalArray
    }
    
}
