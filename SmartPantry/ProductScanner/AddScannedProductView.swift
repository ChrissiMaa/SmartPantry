//
//  AddScannedProductView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 27.07.25.
//
import SwiftData
import SwiftUI

struct AddScannedProductView: View {
    
    @Query private var pantryLists: [PantryList]
    @State private var selectedPantryList: PantryList?
    
    @Binding var newPantryItem: PantryItem
    @State private var isEditingExpiryDate: Bool = false
    @State private var selectedMinUnit: Unit = .piece
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    //var onSave: () -> Void
    
    var body: some View {
        NavigationView {
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
                        Image("Salat")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 50)
                            .clipped()
                        TextField("Name", text: $newPantryItem.name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.gray)
                    }
                }
                Section {
                    PantryItemQuantityView(item: newPantryItem)
                }
                // Haltbarkeitsdatum und Kaufdatum
                Section {
                    PantryItemDatesView(item: newPantryItem, isEditingExpiryDate: $isEditingExpiryDate)
                }
                // TODO: Ggf. sicherstellen, dass nur Zahlen eingegeben werden dürfen
                Section {
                    VStack(alignment: .leading) {
                        Text("Barcode").font(.caption)
                        TextField("Barcode", text: Binding(
                            get: { newPantryItem.barcode ?? "" },
                            set: { newPantryItem.barcode = $0.isEmpty ? nil : $0 }
                        ))
                    }
                }
                Section {
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
                }
                //Mindestmenge
                //if item.minimumQuantity != nil {
                    Section {
                        HStack {
                            VStack (alignment: .leading){
                                Text("Mindestmenge").font(.caption)
                                HStack {
                                    TextField("Mindestmenge", text: Binding(
                                        get : { String(newPantryItem.quantity) },
                                        set : {
                                            if let value = Int($0), value > 0 {
                                                newPantryItem.quantity = value
                                            } else {
                                                newPantryItem.quantity = 1
                                            }
                                        }
                                    ))
                                    .keyboardType(.numberPad)
                                    
                                    Stepper("", value: $newPantryItem.quantity, in: 1...100)
                                        .labelsHidden()
                                }
                               
                            }
                            Spacer()
                            VStack (alignment: .leading){
                                Text("Einheit").font(.caption)
                                Picker ("", selection: $selectedMinUnit) {
                                    ForEach(Unit.allCases) { unit in
                                        Text(unit.rawValue).tag(unit)
                                    }
                                }
                                .pickerStyle(.navigationLink)
                                //.labelsHidden()
                            }
                        }
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
                        //onSave()
                        
                    }
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
            
        var body: some View {
            AddScannedProductView(newPantryItem: $sampleItem)
        }
    }
    
    return AddScannedProductViewPreviewWrapper()
}


