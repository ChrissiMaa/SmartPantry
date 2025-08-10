//
//  PantryItemQuantityView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 22.05.25.
//

import SwiftUI

struct PantryItemQuantityView: View {
    
    @Bindable var item: PantryItem

    var body: some View {
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
                Picker ("", selection: $item.unit) {
                    ForEach(Unit.allCases) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                .pickerStyle(.navigationLink)
                //.labelsHidden()
            }
        }
        //Mindestmenge
        HStack {
            VStack (alignment: .leading){
                Text("Mindestmenge").font(.caption)
                HStack {
                    TextField("Mindestmenge", text: Binding(
                        get : { String(item.minQuantity) },
                        set : {
                            if let value = Int($0), value > 0 {
                                item.minQuantity = value
                            } else {
                                item.minQuantity = 1
                            }
                        }
                    ))
                    .keyboardType(.numberPad)
                    
                    Stepper("", value: $item.minQuantity, in: 1...100)
                        .labelsHidden()
                }
               
            }
            Spacer()
            VStack (alignment: .leading){
                Text("Einheit").font(.caption)
                Picker ("", selection: $item.unit) {
                    ForEach(Unit.allCases) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                .pickerStyle(.navigationLink)
            }
        }
    }
}
            


#Preview {
    PantryItemQuantityView(item: PantryItem(name: "Salat", nutrients: PantryItem.Nutrients(calories: 30, carbohydrates: 5, protein: 2, fat: 1)))
}
