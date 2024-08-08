//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by Ref on 08/08/24.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.3), radius: 10, x: 0, y: 0)
            .padding()
    }
}

#Preview {
    
    Group {
        
        CircleButtonView(iconName: "info")
        
        CircleButtonView(iconName: "plus")
            .colorScheme(.dark)
    }
    
}
