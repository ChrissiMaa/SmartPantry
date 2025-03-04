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
    //var items: [String]
    
    init(name: String) {
        self.name = name
    }
}
