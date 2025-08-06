//
//  PantryListDetailView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 30.03.25.
//

import SwiftUI
import SwiftData

struct PantryListDetailView: View {
    
    @Bindable var pantryList: PantryList //Bindable, weil wir pantryList bearbeiten
    @State private var selectedItems = Set<UUID>()
    
    @State private var editMode: EditMode = .inactive
    @State private var newItem: String = ""
    @State private var searchText: String = ""
    @State private var sortByExpiryDate: Bool = false
    
    @Environment(\.modelContext) var modelContext
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .bottomTrailing){
                List(selection: $selectedItems) {
                    Section(header: Text("Meine Produkte")) {
                        ForEach(sortedItems, id: \.id) { item in
                            PantryItemButton(item: item)
                        }
                        
                        TextField("Neu", text: $newItem)
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                let newItemTrimmed = newItem.trimmingCharacters(in: .whitespacesAndNewlines)
                                if (!newItemTrimmed.isEmpty) {
                                    let newPantryItem = PantryItem(name: newItemTrimmed)
                                    pantryList.pantryItems.append(newPantryItem)
                                    newItem = ""
                                    isTextFieldFocused = true
                                }
                               
                            }
                            .submitLabel(.done)
                    }
                }
                .navigationTitle($pantryList.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        EditButton()
                        if editMode == .active {
                            Button(action: {
                                pantryList.pantryItems.removeAll { item in
                                    selectedItems.contains(item.id)
                                }
                            }, label: {
                                Image(systemName: "trash")
                            })
                        }
                        Menu {
                            Toggle(isOn: $sortByExpiryDate) {
                                Label("Sort by expiry date", systemImage: "calendar")
                            }
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                        }
                    }
                }
                .environment(pantryList)
                .environment(\.editMode, $editMode)
                FloatingAddButton(pantryList: pantryList)
            }
            
        }
        .searchable(text: $searchText)
    }
    
    /// A computed property that returns the list of pantry items filtered by the current search text.
    /// If the search text is empty, all items are returned.
    var filteredItems: [PantryItem] {
        if searchText.isEmpty {
            return pantryList.pantryItems
        } else {
            return pantryList.pantryItems.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    /// A computed property that sorts the given items by expiry date if sorting by expiry date is enabled.
    var sortedItems: [PantryItem] {
        if sortByExpiryDate {
            return filteredItems.sorted {
                ($0.expiryDate ?? Date.distantFuture) < ($1.expiryDate ?? Date.distantFuture)
            }
        } else {
            return filteredItems
        }
    }
}

#Preview {
    @Previewable @State var pantryList = PantryList(name: "Kühlschrank")
    PantryListDetailView(pantryList: pantryList)
}
