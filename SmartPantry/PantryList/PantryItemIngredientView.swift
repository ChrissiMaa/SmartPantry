//
//  PantryItemIngredientView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 22.05.25.
//

import SwiftUI

struct PantryItemIngredientView: View {
    
    @Bindable var item: PantryItem
    @State private var isIngredientsExpanded = false
    
    var body: some View {
        if item.ingredients != nil {
                        Section {
                            DisclosureGroup("Inhaltsstoffe") {
                                TextEditor(text: Binding(
                                    get: { item.ingredients?.joined(separator: ", ") ?? "" }, //Array in String umwandeln
                                    set: { newValue in
                                        let maxCharacterCount = 350
                                        if newValue.count <= maxCharacterCount {
                                            item.ingredients = newValue
                                                .split(separator: ",") //String in Array umwandeln
                                                .map { String($0) }
                                        } else {
                                            let croppedText = String(newValue.prefix(maxCharacterCount))
                                            item.ingredients = croppedText
                                                .split(separator: ",")
                                                .map { String($0) }
                                        }
                                    }
                                ))
                                .swipeActions {
                                    Button("Löschen", role: .destructive) {
                                        item.ingredients = nil
                                    }
                                }
                            }
                        }
                    } else {
                        Section {
                            Button(action: {
                                item.ingredients = []
                                isIngredientsExpanded = true
                            }, label: {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Inhaltsstoffe hinzufügen")
                                }
                            })
                        }
                    }   
    }
}

#Preview {
    PantryItemIngredientView(item: PantryItem(name: "Salat", nutrients: PantryItem.Nutrients(calories: 30, carbohydrates: 5, protein: 2, fat: 1)))
}
