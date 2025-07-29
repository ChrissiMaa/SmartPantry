//
//  OpenFoodFactsAPIService.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 12.05.25.
//

import Foundation

class OpenFoodFactsAPIService {
    
    func fetchProduct(by barcode: String) async throws -> OpenFoodFactsResponse {
        let urlString = "https://world.openfoodfacts.org/api/v2/product/\(barcode)?fields=product_name,brands,nutriments,image_url,ingredients_text,ingredients_analysis_tags"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = urlResponse as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
       // Dekodieren der Antwort
       let decoder = JSONDecoder()
       let response = try decoder.decode(OpenFoodFactsResponse.self, from: data)
       return response
    }
}

