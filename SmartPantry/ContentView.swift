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
            
            Tab("Vorratslisten", systemImage: "carrot") {
                PantryListView()
            }
            
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            ShoppingList.self, PantryList.self
        ], inMemory: true)
}
