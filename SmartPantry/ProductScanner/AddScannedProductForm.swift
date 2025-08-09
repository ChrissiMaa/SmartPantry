//
//  AddScannedProductForm.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 06.08.25.
//

import SwiftUI
import SwiftData

struct AddScannedProductForm: View {
    
    @Query private var pantryLists: [PantryList]
    @State private var selectedPantryList: PantryList?
    
    @Binding var newPantryItem: PantryItem
    @Binding var sheetDetent: PresentationDetent
    
    @State private var isEditingExpiryDate = false
    @State private var selectedMinUnit: Unit = .piece
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Liste auswählen")) {
                Menu {
                    ForEach(pantryLists) { pantryList in
                        Button {
                            selectPantryListAsDefault(pantryList)
                        } label: {
                            Label (pantryList.name, systemImage: selectedPantryList == pantryList ? "checkmark" : "")
                            
                        }
                        
                    }
                }
                label: {
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
                
                
                PantryItemQuantityView(item: newPantryItem)
                
                // Haltbarkeitsdatum und Kaufdatum
                PantryItemDatesView(
                    item: newPantryItem,
                    isEditingExpiryDate: $isEditingExpiryDate,
                    scannerSheet: true,
                    sheetDetent: $sheetDetent)
                
                // TODO: Ggf. sicherstellen, dass nur Zahlen eingegeben werden dürfen
                
                VStack(alignment: .leading) {
                    Text("Barcode").font(.caption)
                    TextField("Barcode", text: Binding(
                        get: { newPantryItem.barcode ?? "" },
                        set: { newPantryItem.barcode = $0.isEmpty ? nil : $0 }
                    ))
                }
                
                
                VStack(alignment: .leading) {
                    Text("Ernährungsform").font(.caption)
                    Picker("", selection: Binding(
                        get: { newPantryItem.plantbasedOption ?? DietType.none },
                        set: { newPantryItem.plantbasedOption = $0 }
                    )) {
                        ForEach(DietType.allCases) { dietType in
                            Text(dietType.rawValue).tag(dietType)
                        }
                    }
                    .pickerStyle(.segmented)
                    //.colorMultiply(.green)
                }
                
                //Mindestmenge
                //if item.minimumQuantity != nil {
                
            }
            /* } else {
             Section {
             Button(action: {
             //item.ingredients = []
             isMinQuantityExpanded = true
             }, label: {
             HStack {
             Image(systemName: "plus")
             Text("Mindestmenge hinzufügen")
             }
             })
             }
             }*/
            
            
            //Nutrients
            PantryItemNutrientsView(item: newPantryItem)
            
            //Ingredients
            PantryItemIngredientView(item: newPantryItem)
            
            //Note
            PantryItemNoteView(item: newPantryItem)
            
            
        }
        .listSectionSpacing(15)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button ("Abbrechen") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Speichern") {
                    guard let pantryList = selectedPantryList else { return }
                    pantryList.pantryItems.append(newPantryItem)
                    dismiss()
                }
            }
            
        }
        .onAppear {
            if let defaultList = pantryLists.first(where: { $0.isDefault }) {
                selectedPantryList = defaultList
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
    struct AddScannedProductViewPreviewWrapper: View {
        @State private var sampleItem = PantryItem(name: "Testprodukt")
        @State private var sheetDetent: PresentationDetent = .large
        
        var body: some View {
            AddScannedProductForm(newPantryItem: $sampleItem, sheetDetent: $sheetDetent)
                .environmentObject(CameraService())
        }
    }
    
    return AddScannedProductViewPreviewWrapper()
}
