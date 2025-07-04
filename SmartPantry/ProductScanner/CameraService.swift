//
//  CameraService.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 04.07.25.
//

import AVFoundation

/// ObservableObject, damit SwiftUI bei Änderungen reagieren kann.
class CameraService: ObservableObject {
    /// Zentrale AVCaptureSession, die Input (Kamera) und Outputs verwaltet.
    let session = AVCaptureSession()

    /// Initializer – startet die Konfiguration direkt beim Erzeugen.
    init() {
        configureSession()
        //Kamera mit Hintergrund-Thread aufrufen (Verhindert UI Hänger)
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    /// Baut die Session auf: legt Auflösung fest, fügt Kamera als Input hinzu und startet die Session.
    private func configureSession() {
        //Beginnt Änderungen an der Session-Konfiguration
        session.beginConfiguration()
        //Setze Qualitätsstufe (z. B. .photo, .high, .low)
        session.sessionPreset = .high

        //Standard Kamera auswählen (Rück-Kamera)
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            print("Kamera-Zugriff fehlgeschlagen")
            return
        }
        //Kamera als Input hinzufügen
        session.addInput(input)
        //Konfigurationsänderungen übernehmen
        session.commitConfiguration()
        

    }
}

