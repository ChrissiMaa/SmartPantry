//
//  ProductScannerView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 03.07.25.
//

import SwiftUI
import SwiftData

///Übergeordnete SwiftUI View, die das Kamerabild anzeigt
struct ProductScannerView: View {
    ///CameraService wird beim App-start initialisiert und hierher übergeben
    @EnvironmentObject var cameraService: CameraService
    
    var apiService: OpenFoodFactsAPIService = OpenFoodFactsAPIService()

    @State private var newPantryItem: PantryItem = PantryItem(name: "")
    
    @State private var showFruitVegSheet: Bool = false
    @State private var showProductSheet: Bool = false
    @State private var errorMessage: String?
    //@State private var showSuccessMessage: Bool = false
    @State private var sheetDetent: PresentationDetent = .large
    @State private var isProductLoaded: Bool = false


    var body: some View {
        ZStack {
            //Live-Kamera
            CameraPreviewView(session: cameraService.session)
                .edgesIgnoringSafeArea([.top, .horizontal])
            
            
            
            // Picker für Scan-Modus
            VStack {
                Spacer()
                VStack(spacing: 12) {
                    Picker("Scan-Modus", selection: $cameraService.scanMode) {
                        ForEach([ScanMode.barcode, ScanMode.vision]) { mode in
                            
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
                .padding(.top, 12)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.6))
            }
            
        }
        .onAppear {
            cameraService.startCameraSession()
            // alle alten Ergebnisse löschen
            cameraService.detectedCode = nil
            cameraService.detectedFruitVeg = nil
            cameraService.detectedDate = nil
            // wieder scannen erlauben
            cameraService.isScanning = true
        }
        .onChange(of: cameraService.scanMode) {
            cameraService.detectedCode = nil
            cameraService.detectedFruitVeg = nil
            cameraService.detectedDate = nil
            cameraService.isScanning = true
        }
        
        .onChange(of: cameraService.detectedCode) {
            guard let barcode = cameraService.detectedCode else { return }
            isProductLoaded = false
            
            Task {
                do {
                    let response = try await apiService.fetchProduct(by: barcode)
                    print("Produktinfos:", response)
                    newPantryItem = toViewModel(response: response)
                    isProductLoaded = true
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
            showProductSheet = true
        }
        .sheet(isPresented: $showProductSheet,
               onDismiss: {
            cameraService.detectedCode = nil
            cameraService.isScanning = true
            cameraService.scanMode = .barcode
            showProductSheet = false
        }) {
            AddScannedProductView(
                newPantryItem: Binding(
                    get: { newPantryItem },
                    set: { newPantryItem = $0 }
                ),
                sheetDetent: $sheetDetent,
                errorMessage: $errorMessage,
                isProductLoaded: $isProductLoaded
                
            )
            .presentationDetents([.fraction(0.15), .large],
                                 selection: $sheetDetent)
            .presentationDragIndicator(.visible)
        }
        .onDisappear {
            cameraService.stopCameraSession()
        }
        .onChange(of: cameraService.detectedDate) { oldDate, newDate in
            guard oldDate == nil, newDate != nil else { return }
            
                cameraService.isScanning = false

                // Sheet hochfahren
                withAnimation(.snappy) {
                    sheetDetent = .large
                }
            
        }

    }
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
