//
//  ExpiryDateParser.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 07.08.25.
//

import Foundation

struct ExpiryDateParser {
    /// Erwartet einen bereits extrahierten Datums-String vom Camera-Service und parsed ihn in ein Date
    static func parseDateString(_ rawDateString: String, now: Date = Date()) -> Date? {
        
        // Trenner normalisieren und Whitespace entfernen
        let normalizedString = rawDateString
            .replacingOccurrences(of: "/", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Berlin")

        // 2-stellige Jahre ab 2000 interpretieren (25 -> 2025)
        if let pivotDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1)) {
            dateFormatter.twoDigitStartDate = pivotDate
        }

        // Versuchen, Formate MIT Jahr zu parsen
        let formatsWithYear = ["dd.MM.yy", "d.M.yy", "dd.MM.yyyy", "d.M.yyyy"]
        for dateFormat in formatsWithYear {
            dateFormatter.dateFormat = dateFormat
            if let parsedDate = dateFormatter.date(from: normalizedString) {
                return parsedDate
            }
        }

        // Falls kein Jahr vorhanden ist -> aktuelles Jahr verwenden
        // Falls Datum bereits vergangen ist -> +1 Jahr
        let formatsWithoutYear = ["dd.MM", "d.M"]
        for dateFormat in formatsWithoutYear {
            dateFormatter.dateFormat = dateFormat
            if let partialDate = dateFormatter.date(from: normalizedString) {
                let components = calendar.dateComponents([.day, .month], from: partialDate)
                
                // Datum mit aktuellem Jahr aufbauen
                var fullDate = calendar.date(from: DateComponents(
                    year: calendar.component(.year, from: now),
                    month: components.month,
                    day: components.day
                ))
                
                // Falls schon vorbei, um 1 Jahr erhöhen
                if let validFullDate = fullDate,
                   calendar.startOfDay(for: validFullDate) < calendar.startOfDay(for: now) {
                    fullDate = calendar.date(byAdding: .year, value: 1, to: validFullDate)
                }
                return fullDate
            }
        }

        // Wenn kein passendes Format gefunden
        return nil
    }
}
