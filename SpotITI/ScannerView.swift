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
	
	@ObservedObject var scanner: ScanditEAN8Scanner

	func makeUIView(context: Context) -> ScanditCaptureCore.DataCaptureView {
		let captureView = DataCaptureView(context: scanner.dataCaptureContext, frame: .zero)
		
		// Create and add the overlay
		let overlay = BarcodeCaptureOverlay(barcodeCapture: scanner.barcodeCapture)
		captureView.addOverlay(overlay)
		
		return captureView
	}

	func updateUIView(_ uiView: ScanditCaptureCore.DataCaptureView, context: Context) {
		
	}
}

struct ScannerCameraView: View {
	@StateObject var scanner = ScanditEAN8Scanner()

	var body: some View {
		VStack {
			ScannerView(scanner: scanner)
				.aspectRatio(3/4, contentMode: .fit)
			Text(scanner.ean8Code ?? "No code scanned yet")
				.font(.title)
				.padding()
		}
	}
}

