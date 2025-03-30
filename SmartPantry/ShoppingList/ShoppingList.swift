//
//  ShoppingList.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 26.02.25.
//

import Foundation
import SwiftData

@Model
class ShoppingList: Identifiable {
    private(set) var id: UUID // privater Setter, kann nur innerhalb der Klasse gesetzt werden (nicht von aussen)

    var name: String
    @Relationship(deleteRule: .cascade) var shoppingItems: [ShoppingItem] //Relationship zu anderem Model für Swift-Data deklarieren. deleteRule löscht alle Items, wenn Liste gelöscht wird
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.shoppingItems = []
    }
}

@Model
class ShoppingItem: Identifiable {
    private(set) var id: UUID // privater Setter, kann nur innerhalb der Klasse gesetzt werden (nicht von aussen)
    
    var name: String
    //var quantity: Int
    var isChecked: Bool
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.isChecked = false
    }
}
