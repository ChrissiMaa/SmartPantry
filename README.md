# SmartPantry

Smart Pantry ist eine in Swift geschriebene iOS-App für das iPhone zur Verwaltung von Lebensmittelvorräten.
Es können Einkaufslisten und Vorratslisten geführt werden. Produkte können per Barcode eingescannt werden oder im Falle von Obst und Gemüse KI-Basiert erkannt werden.
Smart Pantry hilft dabei Lebensmittelvorräte im Blick zu behalten und damit Lebensmittelverschwendung zu reduzieren.

## Voraussetzungen

- **Xcode 16.3 oder höher**
- **iOS 18 oder höher**
- Ein echtes **iPhone** zum Testen der Kamera-Features (Simulator nicht ausreichend)
- Ein MacBook zum Ausführen der App auf dem iPhone

## Installation und Ausführung

1. **Repository klonen**
 ```bash
   git clone https://github.com/ChrissiMaa/SmartPantry.git
 ```
2. **Projekt in XCode öffnen**

3. **Code Signing konfigurieren**  
   Gehe zu **Signing & Capabilities** und:  
   – Wähle ein Apple Developer Team aus  
   – Setze einen individuellen Bundle Identifier  

4. **App auf einem echten Gerät ausführen**  
   Da der Simulator keine Kamera unterstützt, muss die App auf einem echten iPhone getestet werden.  
   – Gerät anschließen  
   – Als Zielgerät in Xcode auswählen  
   – Mit ⌘ + R starten  

## Verwendete Technologien

- Swift & SwiftUI
- SwiftData – Datenpersistenz
- AVFoundation – Kamera- und Barcode-Erkennung  
- Vision – Texterkennung (OCR) und Bilderkenning 
- CoreML – Bildklassifikation für Obst & Gemüse  
