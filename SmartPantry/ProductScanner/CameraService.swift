//
//  CameraService.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 04.07.25.
//

import AVFoundation

/// ObservableObject, damit SwiftUI bei Änderungen reagieren kann.
class CameraService: NSObject, ObservableObject {
    /// Zentrale AVCaptureSession, die Input (Kamera) und Outputs verwaltet.
    let session = AVCaptureSession()

    /// MetadataOutput für Barcodes
    private let metadataOutput = AVCaptureMetadataOutput()
    
    /// Gefundener Barcode als Published, um UI zu benachrichtigen
    @Published var scannedCode: String?
    
    var isScanning = true
    
    /// Initializer – startet die Konfiguration direkt beim Erzeugen.
    /// Ruft den Konstruktor von NSObjekt auf
    override init() {
        super.init()
        
        configureSession()
        // Kamera mit Hintergrund-Thread aufrufen (Verhindert UI Hänger)
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    /// Baut die Session auf: legt Auflösung fest, fügt Kamera als Input hinzu und startet die Session.
    func configureSession() {
        session.beginConfiguration()
        // Setze Qualitätsstufe (z. B. .photo, .high, .low)
        session.sessionPreset = .high

        // Standard Kamera auswählen (Rück-Kamera)
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            print("Kamera-Zugriff fehlgeschlagen")
            return
        }
        //Kamera als Input hinzufügen
        session.addInput(input)
        
        // 2. MetadataOutput für Barcode-Scan hinzufügen
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)

            // Setzt die aktuelle CameraService-Instanz als Delegate für die Metadaten-Erkennung.
            // Dadurch wird die Methode `metadataOutput` automatisch aufgerufen, sobald die Kamera z. B. Barcodes erkennt.
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            // Barcode-Typen, die erkannt werden sollen
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .upce]
        }
                    
        //Konfigurationsänderungen übernehmen
        session.commitConfiguration()
        

    }
}


/// Delegate Methode, die automatisch von AVFoundation aufgerufen wird,
/// sobald ein erkennbares Metadatenobjekt (z.B. ein Barcode) im Kamerabild gebunden wird.
///
/// - Parameters:
///     - output: Das AVCaptureMetadataOutput-Objekt, das die Erkennung ausgelöst hat.
///     - metadataObjects: Eine Liste aller erkannten Metadatenobjekte (z. B. QR-Codes, Barcodes).
///     - connection: Die Verbindung, über die das Bild analysiert wurde.
///
/// Diese Methode extrahiert den ersten erkannten Barcode, prüft ihn auf Gültigkeit
/// und speichert ihn in `scannedCode`. Gleichzeitig wird die weitere Erkennung pausiert,
/// bis der Benutzer die Verarbeitung abgeschlossen hat.
extension CameraService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
           // Scan stoppen, wenn bereits ein Scan läuft
           guard isScanning else { return }

           // Erstes erkannte Objekt aus der Liste prüfen
           guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                 let barcode = metadataObj.stringValue else {
               return
           }

           // Scan kurzzeitig stoppen
           isScanning = false

           // Ergebnis auf dem Hauptthread publizieren (für UI-Update)
           DispatchQueue.main.async {
               self.scannedCode = barcode
               print("Barcode erkannt: \(barcode)")
           }
    }
}

