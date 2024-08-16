//
//  XMarkButton.swift
//  CryptoApp
//
//  Created by Ref on 15/08/24.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode            //used to dismiss the sheet
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        },
        label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XMarkButton()
}
