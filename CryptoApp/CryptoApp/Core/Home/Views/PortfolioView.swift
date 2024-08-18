//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Ref on 14/08/24.
//

import SwiftUI

struct PortfolioView: View {
    
    // @Environment(\.presentationMode) var presentationMode          //used to dismiss the sheet
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                        
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            })
            
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
            
        }
        //Same as above
        //.navigationBarItems(leading: XMarkButton() )
    }
    
}



struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}


extension PortfolioView {
    
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { coin in          // or we can do for just coins in our portfolio
                                                        // (vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) in ForEach loop
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(5)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear
                                        , lineWidth: 1.0)
                        )
                }
            }
            .padding()
        })
    }
    
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id } ),
           let amount = portfolioCoin.currentHoldings {
           quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
        
    }
    
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                    .padding(.leading)
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencywith6Decimals() ?? "")
                    .padding(.trailing)
            }
            Divider()
            HStack {
                Text("Amount Holding:")
                    .padding(.leading)
                Spacer()
                TextField("Ex: 1.5", text: $quantityText )
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing)
                    .keyboardType(.decimalPad)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                hideKeyboard()
                            }
                        }
                    }
            }
            Divider()
            HStack {
                Text("Current Value:")
                    .padding(.leading)
                Spacer()
                Text(getCurrentValue().asCurrencywith2Decimals())
                    .padding(.trailing)
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    
    private var trailingNavBarButtons: some View {
        ZStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
            
            )
            
        }
        .font(.headline)
    }
    
    
    private func saveButtonPressed() {
        guard 
            let coin = selectedCoin,
            let amount = Double(quantityText)
            else { return }
        
        //save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        
        //show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        //hide the keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
            
        }
        
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
    
}
