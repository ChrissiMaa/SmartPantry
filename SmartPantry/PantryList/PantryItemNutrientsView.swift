//
//  PantryItemNutrientsView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 22.05.25.
//

import SwiftUI

struct PantryItemNutrientsView: View {
    
    @Bindable var item: PantryItem
    @State private var showNutrients = false
    @State private var showSheet = false
    
    var body: some View {
        if item.nutrients != nil {
            Section() {
                DisclosureGroup("Nährwerte", isExpanded: $showNutrients) {
                    VStack {
                        HStack {
                            Text("Kalorien")
                            Spacer()
                            TextField("Kalorien", text: Binding(
                                get: { String(item.nutrients?.calories ?? 0) },
                                set: { item.nutrients?.calories = Double($0) ?? 0 }
                            ))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Text("Kohlenhydrate")
                            Spacer()
                            TextField("Kohlenhydrate", text: Binding(
                                get: { String(item.nutrients?.carbohydrates ?? 0) },
                                set: { item.nutrients?.carbohydrates = Double($0) ?? 0 }
                            ))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Text("Proteine")
                            Spacer()
                            TextField("Proteine", text: Binding(
                                get: { String(item.nutrients?.protein ?? 0) },
                                set: { item.nutrients?.protein = Double($0) ?? 0 }
                            ))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Text("Fett")
                            Spacer()
                            TextField("Fett", text: Binding(
                                get: { String(item.nutrients?.fat ?? 0) },
                                set: { item.nutrients?.fat = Double($0) ?? 0 }
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
    }
}

#Preview {
    PantryItemNutrientsView(item: PantryItem(name: "Salat", nutrients: PantryItem.Nutrients(calories: 30, carbohydrates: 5, protein: 2, fat: 1)))
}
