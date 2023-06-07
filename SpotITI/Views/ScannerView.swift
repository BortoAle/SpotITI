//
//  ScannerView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 13/05/23.
//

import SwiftUI
import ScanditCaptureCore
import ScanditBarcodeCapture

struct ScannerView: UIViewRepresentable {
	
	@ObservedObject var scanner: ScanManager

	func makeUIView(context: Context) -> ScanditCaptureCore.DataCaptureView {
		let captureView = DataCaptureView(context: scanner.dataCaptureContext, frame: .zero)
		
		// Create and add the overlay
//		let overlay = BarcodeCaptureOverlay(barcodeCapture: scanner.barcodeCapture)
//		captureView.addOverlay(overlay)
		
		return captureView
	}

	func updateUIView(_ uiView: ScanditCaptureCore.DataCaptureView, context: Context) {}
	
}
