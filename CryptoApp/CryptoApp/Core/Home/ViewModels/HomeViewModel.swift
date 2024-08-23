//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Ref on 10/08/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticsModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    @Published var isLoading : Bool = false
    @Published var sortOption: SortOption = .holdings
    
    
    private let coinDataService = CoinDataService()
    
    private let marketDataService = MarketDataService()
    
    private let portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        //        dataService.$allCoins
        //            .sink { [weak self] returnedCoins in
        //                self?.allCoins = returnedCoins
        //            }
        //            .store(in: &cancellables)
        
        
        //updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        //updates the portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }              //make sure that we have the reference to self
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        
        //updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
    }
    
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
        
    }
    
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var filteredCoins = filterCoins(text: text, coins: coins)
        let sortedCoins = sortCoins(sort: sort, coins: filteredCoins)
        return sortedCoins
    }
    
    
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        let filteredCoins = coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
        return filteredCoins
    }
    
    
    
    private func sortCoins(sort: SortOption, coins: [CoinModel]) -> [CoinModel] {
        switch sort {
        
//        case .rank:
//            return coins.sorted { coin1, coin2 in
//                return coin1.rank < coin2.rank
//            }  same as above code
        
        case .rank, .holdings:
            return coins.sorted(by: { $0.rank < $1.rank })
        
        case .rankReversed, .holdingsReversed:
            return coins.sorted(by: { $0.rank > $1.rank })
            
        case.price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
            
        case .priceReversed:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
            
        }
    }
    
    
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        // wil only sort by holdings or reversedHoldings if needed
        switch sortOption {
        
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        
        default:
            return coins
        }
    }
    
    
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {

            allCoins
                .compactMap { (coin) -> CoinModel? in
                    guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                        return nil
                    }
                    return coin.updateHoldings(amount: entity.amount)
                }
        
    }
    
    
    
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        stats.append(marketCap)
        
        let volume = StatisticsModel(title: "24H Volume", value: data.volume)
        stats.append(volume)
        
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
        stats.append(btcDominance)
        
        
//        let portfolioValue = portfolioCoins.map { (coin) -> Double in
//            return coin.currentHoldingsValue
//        }
//        same as the below statement
        
        
        let portfolioValue = 
            portfolioCoins
                .map({ $0.currentHoldingsValue })
                .reduce(0, +)                     // reduce can be used to sum things in swift
        
        let previousValue =
            portfolioCoins
                .map { (coin) -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = coin.priceChangePercentage24H ?? 0 / 100         // it returns whole number so we need to divide it by 100 ti get the                                                                         actual percentage change
                    let previousValue = currentValue / (1 + percentChange)               // Eg - 110 / (1 + 0.10) = 100
                    return previousValue
                }
                .reduce(0, +)            // previous value of our Portfolio 24H back
        
        
        let percentageChange = ( (portfolioValue - previousValue) / previousValue )
        
        
        let portfolio = StatisticsModel(title: "Portfolio Value", value: portfolioValue.asCurrencywith2Decimals(), percentageChange: percentageChange)
        stats.append(portfolio)
        
//                or we can combine this instead of doing it for each one
//                stats.append(contentsOf: [
//                    marketCap,
//                    volume,
//                    btcDominance,
//                    portfolio
//                ])
        return stats
    }
    
    
}

