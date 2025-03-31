//
//  PantryItemButton.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 31.03.25.
//

import Foundation
import SwiftUI

struct PantryItemButton: View {
    
    @Environment(PantryList.self) var pantryList: PantryList
    var item: PantryItem
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        Button(action: {
           
        }, label: {
            Text(item.name)
        })
        .swipeActions {
            Button("Löschen", role: .destructive) {
                let index = pantryList.pantryItems.firstIndex(where: { shoppingItem in
                    shoppingItem.id == item.id
                })
                if let index = index {
                    let deletedShoppingItem = pantryList.pantryItems.remove(at: index)
                    modelContext.delete(deletedShoppingItem)
                }
            }
        }
        
    }
}

#Preview {
    PantryItemButton(item: PantryItem(name: "Salat"))
        .environment(PantryList(name: "Vorratsliste"))
}
