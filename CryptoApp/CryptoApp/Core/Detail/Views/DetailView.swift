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
    
    @StateObject private var vm: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var spacing: CGFloat = 30
    
    
//    let coin: CoinModel        not needed
    
    init(coin: CoinModel) {
        
//        self.coin = coin       not needed
        
        //To access the StateObject part of the vm we need to use the _
        
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        
//        print("Initializing Detail View for \(coin.name)")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("\(vm.coin.name)")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text("")
                    .frame(height: 150)
                
                overviewTitle
                
                Divider().background(Color.theme.secondaryText)
                
                overviewGrid
                
                
                additionalTitle
                
                Divider().background(Color.theme.secondaryText)
                
                additionalGrid
                
            }
            .navigationTitle(vm.coin.name)
            .padding(.leading, 15)
        }
        
    }

}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}


extension DetailView {
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticsView(stat: stat)
                }
            }
        )
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticsView(stat: stat)
                }
            }
        )
    }
    
}
