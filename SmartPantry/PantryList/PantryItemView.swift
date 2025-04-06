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
    @State private var selectedDate: Date = Date()
    
    
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
                
                Text("Haltbarkeitsdatum")
                    .font(.headline)
                if isEditingExpiryDate {
                    DatePicker("Wähle ein Datum", selection: $selectedDate, displayedComponents: .date)
                        .onChange(of: selectedDate) { oldDate, newDate in
                            item.expiryDate = newDate
                        }
                            
                } else {
                    if let expiryDate = item.expiryDate {
                        Text("\(expiryDate, formatter: DateFormatter.dateStyle(.medium))")
                            .onTapGesture {
                                isEditingExpiryDate = true
                            }
                    } else {
                        // Falls kein Ablaufdatum gesetzt ist, zeige das heutige Datum an
                        Text("\(selectedDate, formatter: DateFormatter.dateStyle(.medium))")
                            .foregroundColor(.gray)
                            .onTapGesture {
                                isEditingExpiryDate = true
                            }
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
            .onAppear()
            {
                selectedDate = item.expiryDate ?? Date() //Falls kein MHD vorhanden, heutiges Datum
            }
        }
        .toolbar {
            EditButton()
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
