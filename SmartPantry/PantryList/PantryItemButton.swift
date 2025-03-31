//
//  PantryItemButton.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 31.03.25.
//

import SwiftUI

struct PantryItemButton: View {
    
    @Environment(PantryList.self) var pantryList: PantryList
    var item: PantryItem
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    PantryItemButton()
//}
