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
    var quantity: Int
    var barcode: String?
    var expiryDate: Date?
    var dateOfPurchase: Date?
    var nutrients: Nutrients?
    var ingredients: [String]?
    var plantbasedOption: DietType?
    var note: String?
    
    
    init(name: String, barcode: String? = nil, expiryDate: Date? = nil, dateOfPurchase: Date? = nil, nutrients: Nutrients? = nil, ingredients: [String]? = nil, plantbasedOption: DietType? = nil, note: String? = nil) {
        self.id = UUID()
        self.name = name
        self.quantity = 1
        self.barcode = barcode
        self.expiryDate = expiryDate
        self.dateOfPurchase = dateOfPurchase
        self.nutrients = nutrients
        self.ingredients = ingredients
        self.plantbasedOption = plantbasedOption
        self.note = note
    }
    
    struct Nutrients: Codable {
        var calories: Int
        var carbohydrates: Int
        var protein: Int
        var fat: Int
        
        init (calories: Int, carbohydrates: Int, protein: Int, fat: Int) {
            self.calories = calories
            self.carbohydrates = carbohydrates
            self.protein = protein
            self.fat = fat
        }
    }
}

enum Unit: String, CaseIterable, Identifiable, Codable {
    case piece = "Stück"
    case milliliter = "Milliliter"
    case liter = "Liter"
    case gram = "Gramm"
    case kilogram = "Kilogramm"
    case package = "Packung"
    case bottle = "Flasche"
    case crate = "Kasten"
    case jar = "Glas"
    case can = "Dose"
    
    var id: Self { self }
}


enum DietType: String, CaseIterable, Identifiable, Codable {
    case none = "Keine"
    case vegetarian = "Vegetarisch"
    case vegan = "Vegan"
    
    var id: Self { self }
}
