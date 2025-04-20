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
    
    @State private var showNutrients = false
    
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ZStack(alignment: .bottomLeading) {
                        Image("Salat")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 220) // ← hier die Höhe der Section beeinflussen
                            .clipped()
                        TextField("Name", text: $item.name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.gray)
                    }
                }
                Section {
                    HStack {
                        VStack (alignment: .leading){
                            Text("Menge").font(.caption)
                            HStack {
                                TextField("Menge", text: Binding(
                                    get : { String(item.quantity) },
                                    set : {
                                        if let value = Int($0), value > 0 {
                                            item.quantity = value
                                        } else {
                                            item.quantity = 1
                                        }
                                    }
                                ))
                                .keyboardType(.numberPad)
                                
                                Stepper("", value: $item.quantity, in: 1...100)
                                    .labelsHidden()
                            }
                           
                        }
                        Spacer()
                        VStack (alignment: .leading){
                            Text("Einheit").font(.caption)
                            
                        }
                    }
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
                            let daysUntilExpiry = calcDaysUntilExpiry(expiryDate: item.expiryDate ?? Date()) // Default Value Date() ???
                            
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
                    Text("Vegetarisch, Vegan")
                    
                }
                
                if item.nutrients != nil {
                        Section() {
                            DisclosureGroup("Nährwerte", isExpanded: $showNutrients) {
                                VStack {
                                    HStack {
                                        Text("Kalorien")
                                        Spacer()
                                        TextField("Kalorien", text: Binding(
                                            get: { String(item.nutrients?.calories ?? 0) },
                                            set: { item.nutrients?.calories = Int($0) ?? 0 }
                                        ))
                                            .multilineTextAlignment(.trailing)
                                            .keyboardType(.numberPad)
                                    }
                                    
                                    HStack {
                                        Text("Kohlenhydrate")
                                        Spacer()
                                        TextField("Kohlenhydrate", text: Binding(
                                            get: { String(item.nutrients?.carbohydrates ?? 0) },
                                            set: { item.nutrients?.carbohydrates = Int($0) ?? 0 }
                                        ))
                                            .multilineTextAlignment(.trailing)
                                            .keyboardType(.numberPad)
                                    }
                                    
                                    HStack {
                                        Text("Proteine")
                                        Spacer()
                                        TextField("Proteine", text: Binding(
                                            get: { String(item.nutrients?.protein ?? 0) },
                                            set: { item.nutrients?.protein = Int($0) ?? 0 }
                                        ))
                                            .multilineTextAlignment(.trailing)
                                            .keyboardType(.numberPad)
                                    }
                                    
                                    HStack {
                                        Text("Fett")
                                        Spacer()
                                        TextField("Fett", text: Binding(
                                            get: { String(item.nutrients?.fat ?? 0) },
                                            set: { item.nutrients?.fat = Int($0) ?? 0 }
                                        ))
                                            .multilineTextAlignment(.trailing)
                                            .keyboardType(.numberPad)
                                    }
                                }
                            }
                        }
                } else {
                    Button(action: {
                        showSheet = true
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Nährwerte hinzufügen")
                        }
                    })
                    .sheet(isPresented: $showSheet) {
                        AddNutrientsView(item: item)
                            .presentationDetents([.height(650)])
                    }
                }
                Section {
                    DisclosureGroup("Inhaltsstoffe") {
                       
                    }
                }
                Section {
                    DisclosureGroup("Notiz") {
                        
                    }
                }
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

func calcDaysUntilExpiry(expiryDate: Date) -> Int {
    let today = Calendar.current.startOfDay(for: Date())
    let expiry = Calendar.current.startOfDay(for: expiryDate)
    let days = Calendar.current.dateComponents([.day], from: today, to: expiry).day ?? 0
    return days
}

#Preview {
    PantryItemView(item: PantryItem(name: "Salat", nutrients: PantryItem.Nutrients(calories: 30, carbohydrates: 5, protein: 2, fat: 1)))
        .environment(PantryList(name: "Vorrat"))
        .modelContainer( for: [PantryItem.self], inMemory: true)
}
