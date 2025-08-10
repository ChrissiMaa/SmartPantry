//
//  PantryItemDatesView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 27.07.25.
//

import SwiftUI
import SwiftData

struct PantryItemDatesView: View {
    
    @EnvironmentObject var cameraService: CameraService

    @Bindable var item: PantryItem
    @Binding var isEditingExpiryDate: Bool
    
    @State var scannerSheet: Bool
    var sheetDetent: Binding<PresentationDetent>? = nil //Optionales Binding

    
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
                    let startOfToday = Calendar.current.startOfDay(for: Date())
                    
                    DatePicker(
                        "Haltbarkeitsdatum",
                        selection: Binding(
                            get: { item.expiryDate ?? Date() },
                            set: { item.expiryDate = $0 }
                        ),
                        in: startOfToday...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    
                }
                Spacer()
                if (!scannerSheet) {
                    if let expiry = item.expiryDate {
                            let daysUntilExpiry = expiry.daysUntilExpiry()
                            
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
                } else {
                    Button("Datum scannen") {
                        sheetDetent?.wrappedValue = .fraction(0.15)
                        
                        cameraService.detectedDate = nil
                        cameraService.scanMode = .date
                        cameraService.isScanning = true
                    }
                    .buttonStyle(.bordered)
                }
                
            }
                
        }
        .onChange(of: item.expiryDate) { oldValue, newValue in
            guard newValue != oldValue else { return }
            NotificationService.shared.removeNotification(for: item)
            if newValue != nil {
                NotificationService.shared.scheduleNotification(for: item)
            }
        }
        .onChange(of: cameraService.detectedDate) { oldDate, newDate in
            guard let parsedDate = newDate else { return }
            item.expiryDate = parsedDate
            isEditingExpiryDate = false
            withAnimation(.snappy) {
                           sheetDetent?.wrappedValue = .large
                       }
            cameraService.isScanning = false

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
        isEditingExpiryDate: .constant(false),
        scannerSheet: true,
        sheetDetent: .constant(.large)
    )
    .environmentObject(CameraService())
    .environment(PantryList(name: "Testvorrat"))
    .modelContainer(for: [PantryItem.self], inMemory: true)
}
