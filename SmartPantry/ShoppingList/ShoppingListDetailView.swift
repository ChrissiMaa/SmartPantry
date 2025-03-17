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
    
    @State private var newItem: String = ""
    @State private var selectedItems = Set<String>()
    @State private var editMode: EditMode = .active
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView {
            List (selection: $selectedItems) {
                ForEach($shoppingList.shoppingItems) { $item in
                        Button(action: {
                            item.isChecked.toggle()
                        }, label: {
                            //HStack {
                                //Image(systemName: item.isChecked ? "checkmark.circle" : "circle")
                                //.foregroundColor(item.isChecked ? .black : .black)
                                //.font(.title2)
                                Text(item.name)
                                    .strikethrough(item.isChecked, color: .gray)
                                    
                            //}
                            
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
                //.onDelete(perform: { IndexSet in
                //    shoppingList.shoppingItems.remove(atOffsets: IndexSet)
                //})
                
                TextField("Neu", text: $newItem)
                    .onSubmit {
                        let newShoppingItem = ShoppingItem(name: newItem)
                        shoppingList.shoppingItems.append(newShoppingItem)
                        newItem = ""
                    }
                
            }
            .navigationTitle(shoppingList.name)
            .environment(\.editMode, $editMode)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if editMode == .active {
                            editMode = .inactive
                        } else {
                            editMode = .active
                        }
                        print(editMode)
                    }) {
                        Text(editMode == .active ? "Fertig" : "Bearbeiten")
                        }
                }
                
            }
            
        }
    }
}

func deleteSelectedItems(at offsets: IndexSet) {
    
}

#Preview {
    @Previewable @State var shoppingList = ShoppingList(name: "Test") //Durch Previewable ist @State Variable im Preview-Makro nutzbar
    NavigationStack {
        ShoppingListDetailView(shoppingList: shoppingList)
    }
    
}
