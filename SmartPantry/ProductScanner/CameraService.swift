//
//  CameraService.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 04.07.25.
//

import AVFoundation
import Vision

/// Kamera-Service, der eine Kamera-Session aufbaut und für die Bildverarbeitung zuständig ist.
///
/// Für die Barcodeerkennung wird `AVCaptureMetadataOutput` verwendet,
/// Barcodes werden direkt in der Kamerapipeline erkannt ohne, dass manuelle Bildanalyse erforderlichist.
///
/// Für die Erkennung von Mindeshaltbarkeitsdaten wird `AVCaptureVideoDataOutput` verwendet,
/// Haltbarkeitsdaten werden mit Vision auf den einzelnen Videoframes als BildText erkannt.
/// Dazu werden die Pixel über `VideoDataOutput` abgegriffen und an `VNRecognizeTextRequest` übergeben.
///
/// ObservableObject, damit SwiftUI bei Änderungen reagieren kann.
class CameraService: NSObject, ObservableObject {
    /// Zentrale AVCaptureSession, die Input (Kamera) und Outputs verwaltet.
    let session = AVCaptureSession()

    /// MetadataOutput für Barcodes
    private let metadataOutput = AVCaptureMetadataOutput()
    
    /// VideoDataOutput für Haltbarkeitsdaten
    private let videodataOutput = AVCaptureVideoDataOutput()
    
    private var textRecognitionRequest = VNRecognizeTextRequest()

    var isScanning = true
    
    /// Gefundener Barcode als Published, um UI zu benachrichtigen
    @Published var scannedCode: String?
    /// Gefundenes Mindesthaltbarkeitsdatum, um UI zu benachrichtigen
    @Published var detectedDate: String?
    
    
    /// Initializer – startet die Konfiguration direkt beim Erzeugen.
    /// Ruft den Konstruktor von NSObjekt auf
    override init() {
        super.init()
        
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.recognitionLanguages = ["de-DE"]
        
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
        
        // MetadataOutput für Barcode-Scan hinzufügen
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)

            // Setzt die aktuelle CameraService-Instanz als Delegate für die Metadaten-Erkennung.
            // Dadurch wird die Methode `metadataOutput` automatisch aufgerufen, sobald die Kamera z. B. Barcodes erkennt.
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue(label: "camera.metadata.processing"))

            // Barcode-Typen, die erkannt werden sollen
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .upce]
        }
        
        if session.canAddOutput(videodataOutput) {
            session.addOutput(videodataOutput)
            
            videodataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.frame.processing"))
        }
                    
        //Konfigurationsänderungen übernehmen
        session.commitConfiguration()
        

    }
}


/// Delegate Methode, die automatisch von AVFoundation aufgerufen wird,
/// sobald ein erkennbares Metadatenobjekt (z.B. ein Barcode) im Kamerabild gefunden wird.
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

/// Delegate Methode, die automatisch von AVFoundation aufgerufen wird
extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard isScanning,
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        textRecognitionRequest = VNRecognizeTextRequest { [weak self] request, error in
            guard let self,
                  let results = request.results as? [VNRecognizedTextObservation] else { return }
            
            for observation in results {
                guard let candidate = observation.topCandidates(1).first else { continue }
                let text = candidate.string
                
                let pattern = #"\b\d{1,2}[./]\d{1,2}[./]\d{2,4}\b"#
                if let match = text.range(of: pattern, options: .regularExpression) {
                    DispatchQueue.main.async {
                        self.detectedDate = String(text[match])
                        self.isScanning = false
                    }
                    break
                }
            }
        }
        try? requestHandler.perform([textRecognitionRequest])
    }
}
