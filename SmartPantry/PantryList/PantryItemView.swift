//
//  PantryItemView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 31.03.25.
//

import SwiftUI
import SwiftData

struct PantryItemView: View {
    
    @Bindable var item: PantryItem
    
    @State var isEditingExpiryDate: Bool = false
    @State private var selectedDate: Date? = nil
    
    
    
    @State var selectedDiet: DietType = .none
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ZStack(alignment: .bottomLeading) {
                        Image("Salat")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 220)
                            .clipped()
                        TextField("Name", text: $item.name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.gray)
                    }
                }
                Section {
                    PantryItemQuantityView(item: item)
                }
                Section {
                    VStack (alignment: .leading){
                        Text("Haltbarkeitsdatum").font(.caption)
                        HStack {
                            if item.expiryDate == nil {
                                Button("Hinzufügen") {
                                    item.expiryDate = Date()
                                    isEditingExpiryDate = true
                                }
                                .buttonStyle(.bordered)
                            } else {
                                DatePicker(
                                    "Haltbarkeitsdatum",
                                    selection: Binding(
                                        get: { item.expiryDate ?? Date() },
                                        set: { item.expiryDate = $0 }
                                    ),
                                    in: Date()...,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                
                            }
                            Spacer()
                            let daysUntilExpiry = (item.expiryDate ?? Date()).daysUntilExpiry()
                            
                            Text(
                                daysUntilExpiry < 0 ?
                                 "Abgelaufen" :
                                daysUntilExpiry == 0 ?
                                "Läuft heute ab" :
                                daysUntilExpiry == 1 ?
                                "Läuft ab in \(daysUntilExpiry) Tag" :
                                "Läuft ab in \(daysUntilExpiry) Tagen"
                            )
                        }
                            
                    }
                    VStack (alignment: .leading) {
                        Text("Kaufdatum")
                            .font(.caption)
                        DatePicker(
                            "Kaufdatum",
                            selection: Binding(
                                get : { item.dateOfPurchase ?? Date() }, //Setzt das Datum im DatePicker
                                set : { item.dateOfPurchase = $0 } //Setzt item.dateOfPurchase
                            ),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                    }
                }
                // TODO: Ggf. sicherstellen, dass nur Zahlen eingegeben werden dürfen
                Section {
                    VStack(alignment: .leading) {
                        Text("Barcode").font(.caption)
                        TextField("Barcode", text: Binding(
                            get: { item.barcode ?? "" },
                            set: { item.barcode = $0.isEmpty ? nil : $0 }
                        ))
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Ernährungsform").font(.caption)
                        Picker("", selection: Binding(
                            get: { item.plantbasedOption ?? DietType.none },
                            set: { item.plantbasedOption = $0 }
                        )) {
                            ForEach(DietType.allCases) { dietType in
                                Text(dietType.rawValue).tag(dietType)
                            }
                        }
                        .pickerStyle(.segmented)
                        //.colorMultiply(.green)
                    }
                }
                
            //Nutrients
            PantryItemNutrientsView(item: item)
               
            //Ingredients
            PantryItemIngredientView(item: item)
            
            //Note
            PantryItemNoteView(item: item)
                
                
            }
            .listSectionSpacing(15)
        }
    }
}

extension DateFormatter {
    static func dateStyle(_ style: DateFormatter.Style) -> DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = style
            return formatter
        }
}

/*
func calcDaysUntilExpiry(expiryDate: Date) -> Int {
    let today = Calendar.current.startOfDay(for: Date())
    let expiry = Calendar.current.startOfDay(for: expiryDate)
    let days = Calendar.current.dateComponents([.day], from: today, to: expiry).day ?? 0
    return days
}
 */

extension Date {
    func daysUntilExpiry() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        let target = Calendar.current.startOfDay(for: self)
        return Calendar.current.dateComponents([.day], from: today, to: target).day ?? 0
    }
}

#Preview {
    PantryItemView(item: PantryItem(name: "Salat", nutrients: PantryItem.Nutrients(calories: 30, carbohydrates: 5, protein: 2, fat: 1)))
        .environment(PantryList(name: "Vorrat"))
        .modelContainer( for: [PantryItem.self], inMemory: true)
}
