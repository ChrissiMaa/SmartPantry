//
//  AddShoppingListButton.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 04.03.25.
//

import Foundation
import SwiftUI

struct AddShoppingListButton: View {
    
    @State private var showSheet = false
    var body: some View {
        Button(action: {
            showSheet = true
        }, label: {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showSheet) {
            AddShoppingListView()
                .presentationDetents([.height(450)])
            
        }
    }
    
}

#Preview {
    AddShoppingListButton()
}
