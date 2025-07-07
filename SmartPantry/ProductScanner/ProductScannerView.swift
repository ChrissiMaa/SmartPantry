//
//  ProductScannerView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 03.07.25.
//

import SwiftUI

///Übergeordnete SwiftUI View, die das Kamerabild anzeigt
struct ProductScannerView: View {
    ///CameraService wird beim App-start initialisiert und hierher übergeben
    @EnvironmentObject var cameraService: CameraService
    
    @State private var scanMode: ScanMode = .barcode
    @State private var showScanResult = false
    @State private var showDateResult = false

    var body: some View {
        ZStack {
            //Live-Kamera
            CameraPreviewView(session: cameraService.session)
                .edgesIgnoringSafeArea([.top, .horizontal])

            
            // Scan-Ergebnis-Overlay (wenn Barcode erkannt wurde)
           if showScanResult, let code = cameraService.scannedCode {
               VStack(spacing: 20) {
                   Text("Barcode erkannt:")
                   Text(code)
                       .foregroundColor(.green)
                       .multilineTextAlignment(.center)
                       .padding()
                   Button("Fortfahren") {
                       cameraService.isScanning = true
                       cameraService.scannedCode = nil
                       showScanResult = false
                   }
                   .padding()
                   .background(Color.blue)
                   .foregroundColor(.white)
                   .cornerRadius(10)
               }
               .padding()
               .background(Color.black.opacity(0.8))
               .cornerRadius(16)
               .padding()
           }
            
            if showDateResult, let dateString = cameraService.detectedDate {
                VStack(spacing: 20) {
                    Text("Datum erkannt:")
                    Text(dateString)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Fortfahren") {
                        cameraService.isScanning = true
                        cameraService.detectedDate = nil
                        showScanResult = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(16)
                .padding()
            }
            
            
            // Picker + Modus-Anzeige
            VStack {
                Spacer()

                VStack(spacing: 12) {
                    Picker("Scan-Modus", selection: $scanMode) {
                        ForEach(ScanMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    Text("Modus: \(scanMode.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.top, 12)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.6))
            }
            .padding(.bottom, 0)
        }
        .onReceive(cameraService.$scannedCode) { code in
            if code != nil {
                showScanResult = true
            }
        }
        .onReceive(cameraService.$detectedDate) { date in
            if date != nil {
                showDateResult = true
            }
        }
        .onAppear {
            DispatchQueue.global(qos: .userInitiated).async {
                if !cameraService.session.isRunning {
                    cameraService.session.startRunning()
                }
            }
        }
        .onDisappear {
            cameraService.session.stopRunning()
        }
    }
}


enum ScanMode: String, CaseIterable, Identifiable {
    case barcode = "Barcode"
    case vision = "Obst/Gemüse"

    var id: String { self.rawValue }
}


///Dummy-Klasse für CameraService, die keine Kamera initialisiert
///Wird nur für die Preview benötigt
class MockCameraService: CameraService {
    override init() {
            super.init()
            // keine Kamera initialisieren
        }
    
    override func configureSession() {
           // leer, damit keine echte Kamera verwendet wird
       }
}

#Preview {
    ProductScannerView()
        .environmentObject(MockCameraService() as CameraService)
}
