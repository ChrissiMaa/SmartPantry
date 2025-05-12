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
    
    @Environment(\.editMode) private var editMode
    @State private var newItem: String = ""
    @State private var searchText: String = ""
    
    @Environment(\.modelContext) var modelContext
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .bottomTrailing){
                List(selection: $selectedItems) {
                    Section(header: Text("Meine Produkte")) {
                        ForEach(pantryList.pantryItems, id: \.id) { item in
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
                .environment(pantryList)
                .navigationTitle($pantryList.name)
                .navigationBarTitleDisplayMode(.inline) //TODO: Wieso geht das nicht mit .large ?
                .toolbar {
                    ToolbarItemGroup {
                        EditButton()
                        Button(action: {
                            pantryList.pantryItems.removeAll { item in
                                selectedItems.contains(item.id)
                            }
                        }, label: {
                            Image(systemName: "trash")
                        })
                    }
                }
                
                FloatingAddButton()
            }
            
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    @Previewable @State var pantryList = PantryList(name: "Kühlschrank")
    PantryListDetailView(pantryList: pantryList)
}
