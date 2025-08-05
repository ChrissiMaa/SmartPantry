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
    
    @State private var scanMode: ScanMode = .barcode
    @State private var showScanResult = false
    @State private var showDateResult = false

    @State private var newPantryItem: PantryItem?
    
    @State private var showProductSheet: Bool = false
    @State private var errorMessage: String?
    //@State private var showSuccessMessage: Bool = false


    var body: some View {
        ZStack {
            //Live-Kamera
            CameraPreviewView(session: cameraService.session)
                .edgesIgnoringSafeArea([.top, .horizontal])

               // apiservice mit barcode aufrufen ---DONE--- in onChange
               // response in model transformieren
               // Card anzeigen mit infos für user und auswahlmöglichkeit für liste in der gespreichert werden soll
            
//            if showDateResult, let dateString = cameraService.detectedDate {
//                VStack(spacing: 20) {
//                    Text("Datum erkannt:")
//                    Text(dateString)
//                        .foregroundColor(.green)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                    Button("Fortfahren") {
//                        cameraService.isScanning = true
//                        cameraService.detectedDate = nil
//                        showScanResult = false
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//                .padding()
//                .background(Color.black.opacity(0.8))
//                .cornerRadius(16)
//                .padding()
//            }
            
            
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
                }
                .padding(.top, 12)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.6))
            }
            .padding(.bottom, 0)
        }
//        .onReceive(cameraService.$detectedCode) { code in
//            if code != nil {
//                showScanResult = true
//            }
//        }
        .onReceive(cameraService.$detectedDate) { date in
            if date != nil {
                showDateResult = true
            }
        }
        .onAppear {
            cameraService.startCameraSession()
            cameraService.detectedCode = nil
            cameraService.isScanning = true
        }
        .onDisappear {
            cameraService.stopCameraSession()
        }
        .onChange(of: cameraService.detectedCode) {
            guard let code = cameraService.detectedCode else { return }
            Task {
                do {
                    let response = try await apiService.fetchProduct(by: code)
                    print("Produktinfos:", response)
                    newPantryItem = toViewModel(response: response)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
            showProductSheet = true
        }
        .sheet(isPresented: $showProductSheet) {
            if newPantryItem != nil {
                AddScannedProductView(
                            newPantryItem: Binding(
                                get: { newPantryItem! },
                                set: { newPantryItem = $0 }
                            )
//                            onSave: {
//                                showProductSheet = false
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                    withAnimation {
//                                        showSuccessMessage = true
//                                        print("SuccessMessage:", showSuccessMessage)
//                                    }
//                                }
//                                
//                            }
                            
                            
                        )
                .presentationDetents([.large])
            } else if let error = errorMessage {
                //TODO: Fehlermeldung anpassen
                VStack {
                    Text("Fehler beim Laden")
                        .font(.headline)
                        .padding(.bottom)
                    Text(error)
                        .foregroundColor(.red)
                    Button("Schließen") {
                        showProductSheet = false
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .onChange(of: showProductSheet) { oldValue, newValue in
            if oldValue == true && newValue == false {
                cameraService.detectedCode = nil
                cameraService.isScanning = true
            }
        }

//        .overlay {
//            Group {
//                if showSuccessMessage {
//                    Text ("Produkt hinzugefügt")
//                        padding()
//                        .background(Color.black.opacity(0.8))
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .transition(.opacity)
//                        .onAppear {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                withAnimation {
//                                    showSuccessMessage = false
//                                }
//                            }
//                        }
//                }
//            }
//        }
        

        
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
