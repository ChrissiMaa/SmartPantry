//
//  AddFruitVegView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 09.08.25.
//

import SwiftUI
import SwiftData

struct AddFruitVegView: View {
    
    @Query private var pantryLists: [PantryList]
    @State private var selectedPantryList: PantryList?

    @Binding var newPantryItem: PantryItem
    @Binding var sheetDetent: PresentationDetent

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Liste auswählen")) {
                    Menu {
                        ForEach(pantryLists) { pantryList in
                            Button {
                                selectPantryListAsDefault(pantryList)
                            } label: {
                                Label(pantryList.name, systemImage: selectedPantryList == pantryList ? "checkmark" : "")
                            }
                        }
                    } label: {
                        Text(selectedPantryList?.name ?? "Liste auswählen")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                Section {
                    ZStack(alignment: .bottomLeading) {
                        Image("")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 50)
                            .clipped()
                        VStack (alignment: .leading){
                            Text("Name").font(.caption)
                            TextField("Name", text: $newPantryItem.name)
                                .foregroundColor(.gray)
                        }
                        
                    }
                }

                PantryItemQuantityView(item: newPantryItem)

            }
            .onAppear {
                if selectedPantryList == nil {
                    selectedPantryList = pantryLists.first(where: { $0.isDefault }) ?? pantryLists.first
                }
            }
            .listSectionSpacing(15)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        guard let pantryList = selectedPantryList else { return }
                        pantryList.pantryItems.append(newPantryItem)
                        dismiss()
                    }
                }
            }
        }
    }
    
    func selectPantryListAsDefault(_ newDefaultList: PantryList) {
        pantryLists.forEach { pantryList in
            if pantryList == newDefaultList {
                pantryList.isDefault = true
            } else {
                pantryList.isDefault = false
            }
        }
        selectedPantryList = newDefaultList
    }
    
    func ensureSingleDefaultList() {
        if pantryLists.filter({ $0.isDefault }).isEmpty, let first = pantryLists.first {
            first.isDefault = true
        }
    }
}


#Preview {
    // Dummy-Daten für Preview
    @Previewable @State var sampleItem = PantryItem(name: "Banane")
    @Previewable @State var detent: PresentationDetent = .large
    
    AddFruitVegView(newPantryItem: $sampleItem,
                    sheetDetent: $detent
    )
}
