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

func toViewModel(response: OpenFoodFactsResponse) -> PantryItem {
    return PantryItem(
        name: response.product.product_name ?? "",
        barcode: response.code,
        expiryDate: nil,
        dateOfPurchase: nil,
        nutrients: toViewModel(nutriments: response.product.nutriments),
        ingredients: toViewModel(ingredients: response.product.ingredients_text),
        plantbasedOption: nil,
        note: nil
    )
}

func toViewModel(nutriments: Nutriments?) -> PantryItem.Nutrients {
    return PantryItem.Nutrients(
        calories: nutriments?.energyKcal ?? 0.0,
        carbohydrates: nutriments?.carbohydrates ?? 0.0,
        protein: nutriments?.proteins ?? 0.0,
        fat: nutriments?.fat ?? 0.0
    )
}

func toViewModel(ingredients: String?) -> [String] {
    return ingredients?
        .split(separator: ",")
        .map(String.init) ?? []
}
