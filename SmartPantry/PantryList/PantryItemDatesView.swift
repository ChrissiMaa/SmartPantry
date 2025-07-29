//
//  PantryItemDatesView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 27.07.25.
//

import SwiftUI
import SwiftData

struct PantryItemDatesView: View {
    @Bindable var item: PantryItem
    @Binding var isEditingExpiryDate: Bool
    
    var body: some View {
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
        HStack {
            VStack (alignment: .leading) {
                Text("Kaufdatum").font(.caption)
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
            
            Spacer()
        }
        
    }
}

#Preview {
    PantryItemDatesView(
        item: PantryItem(name: "Testitem"),
        isEditingExpiryDate: .constant(false)
    )
    .environment(PantryList(name: "Testvorrat"))
    .modelContainer(for: [PantryItem.self], inMemory: true)
}
