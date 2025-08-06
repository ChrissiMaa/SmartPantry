//
//  NotificationService.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 06.08.25.
//

import Foundation
import UserNotifications

class NotificationService {
    
    ///Singleton
    static let shared = NotificationService()
    
    private init() {}

    ///Fragt nach Erlaubnis für Push-Benachrichtigungen
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Fehler bei Berechtigung: \(error)")
            } else {
                print(granted ? "Berechtigung erteilt" : "Berechtigung verweigert")
            }
        }
    }
    
    /// Plant eine Benachrichtigung für ein Lebensmittel mit Ablaufdatum
    func scheduleNotification(for item: PantryItem) {
        guard let expiryDate = item.expiryDate else { return }
        
        let NotificationCenter = UNUserNotificationCenter.current()
        
        //---Notification am Ablaufdatum---
        let expiryContent = UNMutableNotificationContent()
        expiryContent.title = "Lebensmittel läuft ab"
        expiryContent.body = "\(item.name) läuft heute ab!"
        expiryContent.sound = .default

        //Extrahiert Bestandteile aus expiryDate
        var expiryTriggerDate = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: expiryDate
        )
        expiryTriggerDate.hour = 9
        
        let expiryTrigger = UNCalendarNotificationTrigger(dateMatching: expiryTriggerDate, repeats: false)

        //Notification Request erzeugen
        let expiryRequest = UNNotificationRequest(
            identifier: item.id.uuidString,
            content: expiryContent,
            trigger: expiryTrigger
        )

        NotificationCenter.add(expiryRequest)
        
        
        //---Notification 3 Tag vor Ablaufdatum---
        
        //Datum der Notification
        guard let reminderDate = Calendar.current.date(byAdding: .day, value: -3, to: expiryDate) else { return }
        
        //Notification 3 Tage vor Ablaufdatum
        let earlyReminderContent = UNMutableNotificationContent()
        earlyReminderContent.title = "Lebensmittel läuft bald ab!"
        earlyReminderContent.body = "\(item.name) läuft bald ab!"
        earlyReminderContent.sound = .default
        
        var earlyTriggerDate = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: reminderDate
        )
        earlyTriggerDate.hour = 9
        
        let earlyTrigger = UNCalendarNotificationTrigger(dateMatching: earlyTriggerDate, repeats: false)
        
        let earlyRequest = UNNotificationRequest(
            identifier: item.id.uuidString,
            content: earlyReminderContent,
            trigger: earlyTrigger
        )
        
        NotificationCenter.add(earlyRequest)
    }
    
    func scheduleTestNotification(inSeconds seconds: TimeInterval = 5) {
        let content = UNMutableNotificationContent()
        content.title = "Test-Benachrichtigung"
        content.body = "Das ist eine Testnachricht nach \(Int(seconds)) Sekunden."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        let request = UNNotificationRequest(
            identifier: "test-notification",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Fehler beim Planen der Test-Notification: \(error.localizedDescription)")
            } else {
                print("Test-Notification geplant in \(Int(seconds)) Sekunden")
            }
        }
    }


    ///Entfernt eine Notification
    func removeNotification(for item: PantryItem) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
    }
}
