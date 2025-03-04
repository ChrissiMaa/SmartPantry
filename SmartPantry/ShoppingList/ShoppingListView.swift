//
//  SwiftUIView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 26.02.25.
//

import SwiftUI
import SwiftData


struct ShoppingListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var shoppingLists: [ShoppingList]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(shoppingLists) {shoppingList in
                    NavigationLink(value: shoppingList) {
                        Text(shoppingList.name)
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    AddShoppingListButton()
                }
            }
            .navigationTitle("Einkaufslisten")
            .navigationDestination(for: ShoppingList.self) {
                shoppingList in
                ShoppingListDetailView(shoppingList: shoppingList)
            }
        }
    }
}

#Preview {
    ShoppingListView()
        .modelContainer(for: [
            ShoppingList.self
        ], inMemory: true)
}
