//
//  AddPantryListButton.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 30.03.25.
//

import Foundation
import SwiftUI

struct AddPantryListButton: View {
    
    @State private var showSheet = false
    var body: some View {
        Button(action: {
            showSheet = true
        }, label: {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showSheet) {
            AddPantryListView()
                .presentationDetents([.height(450)])
            
        }
    }
    
}

#Preview {
    AddPantryListButton()
}
