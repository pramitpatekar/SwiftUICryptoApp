//
//  DetailView.swift
//  CryptoApp
//
//  Created by Ref on 19/08/24.
//

import SwiftUI


struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
    
}


struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    
//    let coin: CoinModel        not needed
    
    init(coin: CoinModel) {
        
//        self.coin = coin       not needed
        
        //To access the StateObject part of the vm we need to use the _
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing Detail View for \(coin.name)")
    }
    
    var body: some View {
        Text("Hello")
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
