//
//  SmartPantryApp.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 10.02.25.
//

import SwiftUI
import SwiftData

@main
struct SmartPantryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    ShoppingList.self,
                    ShoppingItem.self
                ])
        }
    }
}
