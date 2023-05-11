//
//  CameraPreviewView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
	let session: AVCaptureSession

	func makeUIView(context: Context) -> UIView {
		let view = UIView(frame: UIScreen.main.bounds)
		let previewLayer = AVCaptureVideoPreviewLayer(session: session)
		previewLayer.frame = view.bounds
		previewLayer.videoGravity = .resizeAspectFill
		view.layer.addSublayer(previewLayer)
		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {}
}
