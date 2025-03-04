//
//  ShoppingListDetailView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 04.03.25.
//

import Foundation
import SwiftUI
import SwiftData

struct ShoppingListDetailView: View {
    
    @Bindable var shoppingList: ShoppingList
    
    @State private var newItem: String = ""
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List {
            ForEach(shoppingList.shoppingItems) { item in
                Text(item.name)
                //Spacer()
                //Text("Anzahl: \(shoppingItem.quantity)")
                
            }
            TextField("Neu", text: $newItem)
                .onSubmit {
                    let newShoppingItem = ShoppingItem(name: newItem)
                    shoppingList.shoppingItems.append(newShoppingItem)
                    newItem = ""
                }
            
        }
        .navigationTitle(shoppingList.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                
            }
        }
    }
}

#Preview {
    @Previewable @State var shoppingList = ShoppingList(name: "Test") //Durch Previewable ist @State Variable im Preview-Makro nutzbar
    NavigationStack {
        ShoppingListDetailView(shoppingList: shoppingList)
    }
    
}
