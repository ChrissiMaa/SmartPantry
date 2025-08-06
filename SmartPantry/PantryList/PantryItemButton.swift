//
//  PantryItemButton.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 31.03.25.
//

import Foundation
import SwiftUI

struct PantryItemButton: View {
    
    @Environment(PantryList.self) var pantryList: PantryList
    @Bindable var item: PantryItem
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationLink(destination: PantryItemView(item: item)) {
            HStack {
                Text(item.name)
                Spacer()
                
                if let expiryDate = item.expiryDate {
                    let daysUntilExpiry = expiryDate.daysUntilExpiry()
                    let color = colorForDaysUntilExpiry(daysUntilExpiry)
                   
                    Text("In \(daysUntilExpiry) Tagen")
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(color.opacity(0.1))
                        .foregroundColor(color)
                        .clipShape(Capsule())
                }
                
            }
            
        }
        .swipeActions {
            Button("Löschen", role: .destructive) {
                NotificationService.shared.removeNotification(for: item)
                let index = pantryList.pantryItems.firstIndex(where: { shoppingItem in
                    shoppingItem.id == item.id
                })
                if let index = index {
                    let deletedShoppingItem = pantryList.pantryItems.remove(at: index)
                    modelContext.delete(deletedShoppingItem)
                }
            }
        }
        
    }
    
    //Determines color for pill-badges based on the number of days until expiry
    func colorForDaysUntilExpiry(_ daysUntilExpiry: Int) -> Color {
        switch daysUntilExpiry {
        case 7...:
            return Color(red: 89/255, green: 205/255, blue: 144/255) //gruen
        case 3...6:
            return Color(red: 250/255, green: 192/255, blue: 94/255) //gelb
        case 1...2:
            return Color(red: 247/255, green: 157/255, blue: 132/255) //orange
        case ...0:
            return Color(red: 238/255, green: 99/255, blue: 82/255) //rot
        default:
            return .gray
        }
    }
}



#Preview {
    PantryItemButton(item: PantryItem(name: "Salat"))
        .environment(PantryList(name: "Vorratsliste"))
}
