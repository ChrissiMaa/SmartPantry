//
//  PantryListView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 30.03.25.
//

import SwiftUI
import SwiftData

struct PantryListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var pantryLists: [PantryList]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pantryLists) { pantryList in
                    NavigationLink(value: pantryList) {
                        Text(pantryList.name)
                    }
                    .swipeActions {
                        Button("Löschen", role: .destructive) {
                            modelContext.delete(pantryList)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    AddPantryListButton()
                }
            }
            .navigationTitle("Vorratslisten")
            .navigationDestination(for: PantryList.self) {
                pantryList in
                PantryListDetailView(pantryList: pantryList)
            }
        }
    }
}

#Preview {
    PantryListView()
        .modelContainer(for: [
            PantryList.self
        ], inMemory: true)
}
