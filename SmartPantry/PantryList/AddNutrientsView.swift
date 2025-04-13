//
//  AddNutrientsView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 13.04.25.
//

import SwiftUI

struct AddNutrientsView: View {
    
    @Bindable var item: PantryItem
    
    @State private var calories: String = ""
    @State private var carbohydrates: String = ""
    @State private var protein: String = ""
    @State private var fat: String = ""
    
    
    var body: some View {
        Form {
            Section(header: Text("Nährwerte")) {
                HStack {
                    Text("Kalorien")
                    Spacer()
                    TextField("0", text: $calories)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }
                
                HStack {
                    Text("Kohlenhydrate")
                    Spacer()
                    TextField("0", text: $carbohydrates)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }
                
                HStack {
                    Text("Proteine")
                    Spacer()
                    TextField("0", text: $protein)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }
                
                HStack {
                    Text("Fett")
                    Spacer()
                    TextField("0", text: $fat)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }
            }
            
            Button(action: {
                let nutrients = PantryItem.Nutrients(
                    calories: Int(calories) ?? 0,
                    carbohydrates: Int(carbohydrates) ?? 0,
                    protein: Int(protein) ?? 0,
                    fat: Int(fat) ?? 0)
                item.nutrients = nutrients
                
            }) {
                Text("Speichern")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
      
    }
}

#Preview {
    AddNutrientsView(
        item: PantryItem(name: "Salat")
    )
}
