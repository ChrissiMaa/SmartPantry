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
    
    @Bindable var shoppingList: ShoppingList //Bindable weil wir shoppingList bearbeiten
    @State private var selectedItems = Set<UUID>()
    
    @Environment(\.editMode) private var editMode
    @State private var newItem: String = ""
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView {
            List (selection: $selectedItems) {
                ForEach(shoppingList.shoppingItems, id: \.id) { item in
                    Button(action: {
                        item.isChecked.toggle()
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



#Preview {
    @Previewable @State var shoppingList = ShoppingList(name: "Test") //Durch Previewable ist @State Variable im Preview-Makro nutzbar
    NavigationStack {
        ShoppingListDetailView(shoppingList: shoppingList)
    }
    
}
