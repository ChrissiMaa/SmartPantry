//
//  PantryItemNutrientsView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 22.05.25.
//

import SwiftUI

/// A reusable input row for editing a single nutrient value (e.g. calories, fat).
/// Handles user input, number formatting, decimal sanitization, and  unit display.
struct NutrientInputRow: View {
    let title: String
    let unit: String?
    @Binding var value: Double
    @FocusState var isFocused: Bool
    @State private var input: String = ""
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            HStack {
                TextField(title, text: $input)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                    .onChange(of: isFocused) { _, focused in
                        if !focused {
                            let sanitized = input.replacingOccurrences(of: ",", with: ".")
                            if let newValue = Double(sanitized) {
                                value = newValue
                                input = formatDouble(newValue)
                            }
                        }
                    }
                
                if !isFocused, let unit = unit {
                    Text(unit)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
        }
        .onAppear {
            input = formatDouble(value)
        }
    }

    private func formatDouble(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: number)) ?? "0,0"
    }
}

/// Displays the nutrient information (calories, carbohydrates, protein, fat)
/// for a given `PantryItem`. If no nutrients exist, it offers a button to add them.
/// Each nutrient is shown using a reusable `NutrientInputRow` with formatting and validation.
struct PantryItemNutrientsView: View {
    
    @Bindable var item: PantryItem
    @State private var showNutrients = false
    @State private var showSheet = false
    
    @FocusState private var isCaloriesFocused: Bool
    @FocusState private var isCarbsFocused: Bool
    @FocusState private var isProteinFocused: Bool
    @FocusState private var isFatFocused: Bool
    
    var body: some View {
        if item.nutrients != nil {
            Section {
                DisclosureGroup("Nährwerte", isExpanded: $showNutrients) {
                    VStack {
                        NutrientInputRow(
                            title: "Kalorien",
                            unit: "kcal",
                            value: Binding(
                                get: { item.nutrients?.calories ?? 0 },
                                set: { item.nutrients?.calories = $0 }
                            ),
                            isFocused: _isCaloriesFocused
                        )
                        
                        NutrientInputRow(
                            title: "Kohlenhydrate",
                            unit: "g",
                            value: Binding(
                                get: { item.nutrients?.carbohydrates ?? 0 },
                                set: { item.nutrients?.carbohydrates = $0 }
                            ),
                            isFocused: _isCarbsFocused
                        )
                        
                        NutrientInputRow(
                            title: "Proteine",
                            unit: "g",
                            value: Binding(
                                get: { item.nutrients?.protein ?? 0 },
                                set: { item.nutrients?.protein = $0 }
                            ),
                            isFocused: _isProteinFocused
                        )
                        
                        NutrientInputRow(
                            title: "Fett",
                            unit: "g",
                            value: Binding(
                                get: { item.nutrients?.fat ?? 0 },
                                set: { item.nutrients?.fat = $0 }
                            ),
                            isFocused: _isFatFocused
                        )
                    }
                    .swipeActions {
                        Button("Löschen", role: .destructive) {
                            item.nutrients = nil
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
