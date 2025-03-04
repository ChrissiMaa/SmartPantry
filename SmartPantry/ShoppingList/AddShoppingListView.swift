//
//  NewShoppingListView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 04.03.25.
//

import Foundation
import SwiftUI
import SwiftData

struct AddShoppingListView: View {
    
    @State private var caption = ""
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                TextField("Bezeichnung", text: $caption)
            }
            
            Section {
                Button("Speichern") {
                    let newShoppingList = ShoppingList(name: caption)
                    modelContext.insert(newShoppingList)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddShoppingListView()
        .modelContainer(for: [
            ShoppingList.self
        ], inMemory: true)
}





