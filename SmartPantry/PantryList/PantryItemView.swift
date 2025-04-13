//
//  PantryItemView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 31.03.25.
//

import SwiftUI

struct PantryItemView: View {
    
    @Bindable var item: PantryItem
    
    @State var isEditingName: Bool = false
    
    @State var isEditingExpiryDate: Bool = false
    @State private var selectedDate: Date? = nil
    
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                Text("Name")
                    .font(.headline)
                
                if isEditingName {
                    TextField("Name", text: $item.name)
                        .onSubmit {
                            isEditingName = false
                        }
                } else {
                    Text(item.name)
                        .onTapGesture {
                            isEditingName = true
                        }
                }
                
                Divider()
                
                Text("Barcode")
                    .font(.headline)
                if let barcode = item.barcode {
                    Text("\(barcode)")
                }
                
                Divider()
                
                Text("Anzahl")
                    .font(.headline)
                Text("\(item.quantity)")
                
                Divider()
                
                HStack {
                    Text("Haltbarkeitsdatum")
                        .font(.headline)
                    Spacer()
                    if item.expiryDate == nil {
                        Button("Hinzufügen") {
                            item.expiryDate = Date()
                            isEditingExpiryDate = true
                        }
                        .buttonStyle(.bordered)
                    } else {
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { item.expiryDate ?? Date() },
                                set: { item.expiryDate = $0 }
                            ),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        
                    }
                    
                }
                
                Divider()
                
                Text("Kaufdatum")
                    .font(.headline)
                if let dateOfPurchase = item.dateOfPurchase {
                    Text("\(dateOfPurchase)")
                }
                
                Spacer()
                
            }
            
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


#Preview {
    PantryItemView(item: PantryItem(name: "Salat"))
        .environment(PantryList(name: "Vorrat"))
}
