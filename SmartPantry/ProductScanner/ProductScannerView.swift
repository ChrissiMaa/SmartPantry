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

    var body: some View {
        ZStack {
            //Live-Kamera im Hintergrund
            CameraPreviewView(session: cameraService.session)
                .edgesIgnoringSafeArea([.top, .horizontal])


            //Ein Overlay-Label obenauf
            VStack {
                Spacer()
                Text(" Live-Kamera läuft")
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}


#Preview {
    ProductScannerView()
}
