//
//  AddScannedProductView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 27.07.25.
//
import SwiftData
import SwiftUI

struct AddScannedProductView: View {
    
    @Query private var pantryLists: [PantryList]
    @State private var selectedPantryList: PantryList?
    
    @Binding var newPantryItem: PantryItem
    @State private var isEditingExpiryDate: Bool = false
    @State private var selectedMinUnit: Unit = .piece
    
    @Binding var sheetDetent: PresentationDetent
    @Binding var errorMessage: String?
    @Binding var isProductLoaded: Bool

    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    //var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Group {
                if let error = errorMessage {
                    VStack(spacing: 20) {
                        Text("Fehler beim Laden, versuche es erneut")
                            .font(.headline)
                        Text(error)
                            .foregroundColor(.red)
                        Button("Schließen") {
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else if isProductLoaded == false {
                    VStack(spacing: 20) {
                        ProgressView("Produktdaten werden geladen ...")
                        .progressViewStyle(CircularProgressViewStyle())
                    }
                    .padding()
                }
                else {
                    AddScannedProductForm(
                        newPantryItem: Binding(
                            get: { newPantryItem },
                            set: { newPantryItem = $0 }
                        ),
                        sheetDetent: $sheetDetent
                    )
                }
            }
            
        }
    }
}


#Preview {
    struct AddScannedProductViewPreviewWrapper: View {
        @State private var sampleItem = PantryItem(name: "Testprodukt")
        @State private var sheetDetent: PresentationDetent = .large
        @State private var errormessage: String? = nil
        @State private var isProductLoaded: Bool = true
            
        var body: some View {
            AddScannedProductView(newPantryItem: $sampleItem, sheetDetent: $sheetDetent, errorMessage: $errormessage, isProductLoaded: $isProductLoaded)
        }
    }
    
    return AddScannedProductViewPreviewWrapper()
}


