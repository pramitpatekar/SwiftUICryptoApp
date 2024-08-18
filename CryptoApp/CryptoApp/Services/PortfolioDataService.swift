//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Ref on 16/08/24.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error Loading Core Data. \(error)")
            }
            self.getPortfolio()
        }
    }
    
    
    //PUBLIC
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
     // if let entity = savedEntities.first(where: { $0.coinID == coin.id } {  }                  same as below statement
        
        //check if coin is already in the portfolio
        
        if let entity = savedEntities.first(where: { (savedEntity) in
            return savedEntity.coinID == coin.id
        }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
              delete(entity: entity)
                
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    
    //PRIVATE
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching Portfolio Entities. \(error)")
        }
        
    }
    
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error Saving to Core Data. \(error)")
        }
    }
    
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
}

