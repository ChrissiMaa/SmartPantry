//
//  FloatingAddButton.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 12.05.25.
//

import SwiftUI

struct FloatingAddButton: View {
    
    @Bindable var pantryList: PantryList
    @State private var showSheet: Bool = false
    
    var body: some View {
        Button {
            showSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.title.weight(.semibold))
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
        .padding()
        .sheet(isPresented: $showSheet) {
            EnterBarcodeView(pantryList: pantryList)
                .presentationDetents([.height(450)])
            
        }
    }
}

#Preview {
    FloatingAddButton(pantryList: PantryList(name: "Vorrat"))
}
