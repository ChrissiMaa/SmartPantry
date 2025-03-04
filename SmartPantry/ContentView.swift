//
//  ContentView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 10.02.25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Tab("Einkaufslisten", systemImage: "cart") {
                ShoppingListView()
            }
            
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            ShoppingList.self
        ], inMemory: true)
}
