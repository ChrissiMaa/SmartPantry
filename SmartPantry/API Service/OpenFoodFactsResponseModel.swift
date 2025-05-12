//
//  ResponseModel.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 12.05.25.
//

import Foundation

struct OpenFoodFactsResponse: Decodable {
     let code: String
     let product: Product
     let status: Int
     let status_verbose: String

}

struct Product: Decodable {
    let product_name: String?
    let brands: String?
    let image_url: String?
    let ingredients_text: String?
    let nutriments: Nutriments?
    
}

struct Nutriments: Decodable {
    let energyKcal: Double?
    let fat: Double?
    let carbohydrates: Double?
    let proteins: Double?
    
}
