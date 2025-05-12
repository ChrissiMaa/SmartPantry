//
//  OpenFoodFactsAPIService.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 12.05.25.
//

import Foundation

class OpenFoodFactsAPIService {
    
    func fetchProduct(by barcode: String) async throws -> OpenFoodFactsResponse {
       let urlString = "https://world.openfoodfacts.org/api/v2/product/\(barcode)?fields=product_name,brands,nutriments,image_url,ingredients_text"
       
       guard let url = URL(string: urlString) else {
           throw URLError(.badURL)
       }

       let (data, _) = try await URLSession.shared.data(from: url)
       
       // Dekodieren der Antwort
       let decoder = JSONDecoder()
       let response = try decoder.decode(OpenFoodFactsResponse.self, from: data)
       return response
    }
}

