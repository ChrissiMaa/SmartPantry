//
//  PantryItemNoteView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 22.05.25.
//

import SwiftUI

struct PantryItemNoteView: View {
    
    @Bindable var item: PantryItem
    @State private var isNoteExpanded = false
    
    var body: some View {
        if item.note != nil {
            Section {
                DisclosureGroup("Notiz", isExpanded: $isNoteExpanded) {
                    TextEditor(text: Binding(
                        get: { String(item.note ?? "") },
                        set: { newValue in
                            let maxCharacterCount = 350
                            if newValue.count <= maxCharacterCount {
                                item.note = newValue
                            } else {
                                item.note = String(newValue.prefix(maxCharacterCount)) //Text kürzen, wenn über 350 Zeichen lang
                            }
                        }
                    ))
                    .swipeActions {
                        Button("Löschen", role: .destructive) {
                            item.note = nil
                        }
                    }
                }
            }
        } else {
            Section {
                Button(action: {
                    item.note = ""
                    isNoteExpanded = true
                }, label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Notiz hinzufügen")
                    }
                })
            }
            
        }
    }
}

#Preview {
    PantryItemNoteView(item: PantryItem(name: "Salat", nutrients: PantryItem.Nutrients(calories: 30, carbohydrates: 5, protein: 2, fat: 1)))
}
