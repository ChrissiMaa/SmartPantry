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
    
    @FocusState private var isCaloriesFocused: Bool
    @State private var caloriesInput: String = ""
    
    @FocusState private var isCarbsFocused: Bool
    @FocusState private var isProteinFocused: Bool
    @FocusState private var isFatFocused: Bool
    
    var body: some View {
        if item.nutrients != nil {
            Section() {
                DisclosureGroup("Nährwerte", isExpanded: $showNutrients) {
                    VStack {
                        HStack {
                            Text("Kalorien")
                            Spacer()
                            HStack {
                                TextField("Kalorien", text: $caloriesInput)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                                    .focused($isCaloriesFocused)
                                    .onChange(of: isCaloriesFocused) { _, focused in
                                        if !focused {
                                            let sanitized = caloriesInput.replacingOccurrences(of: ",", with: ".")
                                            if let value = Double(sanitized) {
                                                item.nutrients?.calories = value
                                                caloriesInput = formatDouble(value)
                                            }
                                        }
                                    }

                                if !isCaloriesFocused {
                                    Text("kcal")
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isCaloriesFocused = true
                            }
                        }
                        .onAppear {
                            // Beim Start initial befüllen
                            caloriesInput = formatDouble(item.nutrients?.calories ?? 0)
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
    
    func formatDouble(_ number: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 2
            formatter.decimalSeparator = ","
            return formatter.string(from: NSNumber(value: number)) ?? "0,0"
        }
}

#Preview {
    PantryItemNutrientsView(item: PantryItem(name: "Salat", nutrients: PantryItem.Nutrients(calories: 30, carbohydrates: 5, protein: 2, fat: 1)))
}
