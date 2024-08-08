//
//  HomeView.swift
//  CryptoApp
//
//  Created by Ref on 08/08/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        ZStack {
            
            //background layer
            Color.theme.background
                .ignoresSafeArea()
            
            //content layer
            VStack {
                homeHeader
                
                Spacer(minLength: 0)
                
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
}



extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                        .foregroundColor(.blue)
                )
            
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal, 5)
    }
    
}
