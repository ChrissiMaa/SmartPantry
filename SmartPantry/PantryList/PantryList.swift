//
//  PantryList.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 30.03.25.
//

import Foundation
import SwiftData

@Model
class PantryList: Identifiable {
    private(set) var id: UUID //privater Setter, kann nur innerhalb der Klasse gesetzt werden (nicht von aussen)
    var name: String
    @Relationship(deleteRule: .cascade) var pantryItems: [PantryItem] //Relationship zu anderem Model für Swift-Data deklarieren. deleteRule löscht alle Items, wenn Liste gelöscht wird
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.pantryItems = []
    }
}

@Model
class PantryItem {
    private(set) var id: UUID
    var name: String
    //var quantity: Int
    //var barcode: Int
    //var expiryDate: Date
    //var dateOfPurchase: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        //self.quantity = 1
        //self.barcode = barcode
        //self.expiryDate = expiryDate
        //self.dateOfPurchase = dateOfPurchase
    }
}
