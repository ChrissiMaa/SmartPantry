//
//  MultiselectionTest.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 11.03.25.
//

import Foundation
import SwiftUI

struct MultiselectionTest: View {
    
    @Bindable var shoppingList: ShoppingList
    @State private var selectedItems = Set<UUID>()
    
    @Environment(\.editMode) private var editMode
    @State private var newItem: String = ""
    
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView {
            List (selection: $selectedItems) {
                ForEach(shoppingList.shoppingItems) { item in
                    Button(action: {
                        item.isChecked.toggle()
                    }, label: {
                        Text(item.name)
                            .strikethrough(item.isChecked, color: .gray)
                    })
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
                ToolbarItemGroup {
                    EditButton()
                    Button(action: {
                        shoppingList.shoppingItems.removeAll { item in
                            selectedItems.contains(item.id)
                        }
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
            }
        }
        
    }
}
