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
    let ingredients_analysis_tags: [String]?
    let nutriments: Nutriments?
    
}

struct Nutriments: Decodable {
    let energyKcal: Double?
    let fat: Double?
    let carbohydrates: Double?
    let proteins: Double?
    
    //CodingKeys erforderlich, da energy-kcal nicht als Variable gespeichert werden kann
    enum CodingKeys: String, CodingKey {
           case energyKcal = "energy-kcal"
           case fat
           case carbohydrates
           case proteins
       }
}

func toViewModel(response: OpenFoodFactsResponse) -> PantryItem {
    let dietType = dietTypeFromTags(ingredients_analysis_tags: response.product.ingredients_analysis_tags)
    return PantryItem(
        name: response.product.product_name ?? "",
        barcode: response.code,
        expiryDate: nil,
        dateOfPurchase: nil,
        nutrients: toViewModel(nutriments: response.product.nutriments),
        ingredients: toViewModel(ingredients: response.product.ingredients_text),
        plantbasedOption: dietType,
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

/// Determines the appropriate `DietType` based on the `ingredients_analysis_tags` received from the API.
/// - Parameter tags: An optional array of strings representing dietary tags (e.g., "en:vegan", "en:vegetarian").
/// - Returns: A `DietType` value (`.vegan`, `.vegetarian`, or `.none`) depending on the presence of specific tags.
func dietTypeFromTags(ingredients_analysis_tags: [String]?) -> DietType {
    guard let tags = ingredients_analysis_tags else {
        return .none
    }
    print("tags:", tags)
    
    if tags.contains("en:vegan") {
        print("Found vegan")
        return .vegan
    } else if tags.contains("en:vegetarian") {
        print("Found vegetarian")
        return .vegetarian
    } else {
        print("No match found")
        return .none
    }
    
}

