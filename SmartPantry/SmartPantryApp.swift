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
    //Kamera-Service initialisieren
    @StateObject var cameraService = CameraService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cameraService)
                .modelContainer(for: [
                    ShoppingList.self,
                    ShoppingItem.self,
                    PantryList.self,
                    PantryItem.self
                ])
        }
    }
}
