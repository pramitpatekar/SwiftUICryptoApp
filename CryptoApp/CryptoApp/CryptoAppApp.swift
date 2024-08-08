//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Ref on 08/08/24.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
