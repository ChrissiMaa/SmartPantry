//
//  EnterBarcodeView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 12.05.25.
//

import SwiftUI

struct EnterBarcodeView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var apiService: OpenFoodFactsAPIService = OpenFoodFactsAPIService()
    
    @State private var barcode: String = ""
    @State private var errorMessage: String?
    
    
    var body: some View {
        Form {
            Section {
                TextField("Barcode", text: $barcode)
            }
            Section {
                Button("Weiter") {
                    Task {
                        do {
                            let response = try await apiService.fetchProduct(by: barcode)
                            print(response)
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    EnterBarcodeView()
}
