//
//  CameraPreviewView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 04.07.25.
//

import SwiftUI
import AVFoundation

/// UIViewRepresentable erlaubt es, eine UIKit-UIView in SwiftUI zu verwenden.
struct CameraPreviewView: UIViewRepresentable {
    /// Eingebettete UIView, deren Layer wir zu einer Preview-Layer machen.
    class VideoPreviewView: UIView {
        /// Überschreiben, damit Swift das Layer-Type als AVCaptureVideoPreviewLayer anlegt.
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        /// Typ-Safe Zugriff auf das Layer
        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }

    /// Die laufende Session, die wir anzeigen wollen
    let session: AVCaptureSession

    /// Wird einmal aufgerufen, um die UIView zu erzeugen.
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        //Verknüpfen der Preview-Layer mit der Session
        view.previewLayer.session = session
        //Passt das Bild so an, dass der Bildschirm gefüllt wird
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    /// Wird aufgerufen, wenn SwiftUI die View neu rendert
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        uiView.previewLayer.session = session
    }
}
