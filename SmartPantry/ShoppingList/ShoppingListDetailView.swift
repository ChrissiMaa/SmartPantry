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
    @Environment(\.modelContext) var modelContext
    
    @Bindable var shoppingList: ShoppingList //Bindable weil wir shoppingList bearbeiten
    @State private var editMode: EditMode = .inactive

    @State private var selectedItems = Set<UUID>()
    @State private var newItem: String = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            List(selection: $selectedItems) {
                let uncheckedItems = shoppingList.shoppingItems.filter { !$0.isChecked }
                let checkedItems = shoppingList.shoppingItems.filter { $0.isChecked }
                
                Section(header: Text("Meine Produkte")) {
                    ForEach(uncheckedItems, id: \.id) { item in
                        ShoppingItemButton(item: item)
                    }
                    TextField("Neu", text: $newItem)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            let newItemTrimmed = newItem.trimmingCharacters(in: .whitespacesAndNewlines)
                            if (!newItemTrimmed.isEmpty) {
                                let newShoppingItem = ShoppingItem(name: newItemTrimmed)
                                shoppingList.shoppingItems.append(newShoppingItem)
                                newItem = ""
                                isTextFieldFocused = true
                            }
                            
                        }
                        .submitLabel(.done)
                }
                Section(header: Text("Gekaufte Produkte")) {
                    ForEach(checkedItems, id: \.id) { item in
                        ShoppingItemButton(item: item)
                    }
                }
            }
            .navigationTitle($shoppingList.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton()
                    if editMode == .active {
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
            .environment(shoppingList)
            .environment(\.editMode, $editMode)
        }
    }
}


#Preview {
    @Previewable @State var shoppingList = ShoppingList(name: "Test") //Durch Previewable ist @State Variable im Preview-Makro nutzbar
    NavigationStack {
        ShoppingListDetailView(shoppingList: shoppingList)
    }
    
}
