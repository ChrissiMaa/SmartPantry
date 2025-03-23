//
//  ShoppingItemButton.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 23.03.25.
//

import Foundation
import SwiftUI

struct ShoppingItemButton: View {
    
    @Environment(ShoppingList.self) var shoppingList: ShoppingList
    var item: ShoppingItem
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        Button(action: {
            item.isChecked.toggle()
            _ = shoppingList.shoppingItems.partition(by: {
                $0.isChecked
            })
        }, label: {
            Text(item.name)
                .foregroundStyle(item.isChecked ? Color.gray : Color.primary)
                .strikethrough(item.isChecked, color: .gray)
        })
        .swipeActions {
            Button("Löschen", role: .destructive) {
                let index = shoppingList.shoppingItems.firstIndex(where: { shoppingItem in
                    shoppingItem.id == item.id
                })
                if let index = index {
                    let deletedShoppingItem = shoppingList.shoppingItems.remove(at: index)
                    modelContext.delete(deletedShoppingItem)
                }
            }
        }
    }
}
