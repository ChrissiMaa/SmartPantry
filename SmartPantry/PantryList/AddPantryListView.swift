//
//  AddPantryListView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 30.03.25.
//

import Foundation
import SwiftUI
import SwiftData

struct AddPantryListView: View {
    
    @State private var caption = ""
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $caption)
            }
            
            Section {
                Button("Speichern") {
                    let newPantryList = PantryList(name: caption)
                    modelContext.insert(newPantryList)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddPantryListView()
        .modelContainer(for: [
            PantryList.self
        ], inMemory: true)
}
