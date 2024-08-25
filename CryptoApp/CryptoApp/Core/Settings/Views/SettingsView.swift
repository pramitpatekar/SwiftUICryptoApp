//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Ref on 21/08/24.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
    let coffeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let perosnalURL = URL(string: "https://www.nicksarno.com")!
    
    
    var body: some View {
        NavigationView {
            
            ZStack {
                //background
                Color.theme.background         //not working
                    .ignoresSafeArea()
                
                //content
                List {
                    swiftfulThinkingSection
                        .listRowBackground(Color.theme.background)
                    coinGeckoSection
                        .listRowBackground(Color.theme.background)
                    developerSection
                        .listRowBackground(Color.theme.background)
                    applicationSection
                        .listRowBackground(Color.theme.background)
                }
                
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}



extension SettingsView {
    
    private var swiftfulThinkingSection: some View {
        Section(header: Text("Swiftful Thinking")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                // or        .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This App was made by following @SwiftfulThiniking course on YouTube. It uses MVVM Architecture, Combine and CoreData.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            
            Link("Subscribe on YouTube", destination: youtubeURL)
            Link("Support his coffee addiction", destination: coffeeURL)

            
        }
    }
    
    
    private var coinGeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(20)
                // or        .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The CryptoCurrency Data that is used in this App comes from a free API from CoinGecko.")
                
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            
            Link("Visit CoinGecko", destination: coingeckoURL)
            
        }
    }
    
    
    private var developerSection: some View {
        Section(header: Text("Developer")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                
                Text("This App was developed by Pramit Patekar. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers / subscribers and data persistance.")
                
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            
            Link("Visit Website", destination: perosnalURL)
            
        }
    }
 
    
    private var applicationSection: some View {
        Section(header: Text("Application")) {
            
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
            
        }
    }
    
}
