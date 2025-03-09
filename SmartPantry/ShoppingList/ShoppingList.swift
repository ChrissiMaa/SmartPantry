//
//  ShoppingList.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 26.02.25.
//

import Foundation
import SwiftData

@Model
class ShoppingList {
    
    var name: String
    @Relationship(deleteRule: .cascade) var shoppingItems: [ShoppingItem] //Relationship zu anderem Model für Swift-Data deklarieren. deleteRule löscht alle Items, wenn Liste gelöscht wird
    
    init(name: String) {
        self.name = name
        shoppingItems = []
    }
}

@Model
class ShoppingItem {
    var name: String
    //var quantity: Int
    var isChecked: Bool = false
    
    init(name: String) {
        self.name = name
    }
}
