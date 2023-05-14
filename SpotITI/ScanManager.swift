//
//  ScanditEAN8Scanner.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 13/05/23.
//

import ScanditBarcodeCapture
import ScanditCaptureCore

class ScanManager: NSObject, ObservableObject {

	let dataCaptureContext: DataCaptureContext
	let barcodeCapture: BarcodeCapture
	let camera: Camera?
	
	@Published var ean8Code: String?

	override init() {
		
		guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
			  let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
			  let apiKey = dict["API_KEY"] as? String else {
			fatalError("Failed to load API key")
		}

		dataCaptureContext = DataCaptureContext(licenseKey: apiKey)
		
		// Configure Scan Options
		let settings = BarcodeCaptureSettings()
		settings.set(symbology: .ean8, enabled: true)
		barcodeCapture = BarcodeCapture(context: dataCaptureContext, settings: settings)
		
		// Configure Camera
		let cameraSettings = BarcodeCapture.recommendedCameraSettings
		camera = Camera.default
		camera?.apply(cameraSettings)
		dataCaptureContext.setFrameSource(camera, completionHandler: nil)
		camera?.switch(toDesiredState: .on)
		
		super.init()
		
		// Add object listener
		barcodeCapture.addListener(self)
		
		// Create data capture view
		let captureView = DataCaptureView(context: dataCaptureContext, frame: .zero)
		
		// Add the scan overlay
		let overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture)
		captureView.addOverlay(overlay)
		
		// Scart scanning
		barcodeCapture.isEnabled = true
	}
}

extension ScanManager: BarcodeCaptureListener {
	
	func barcodeCapture(_ barcodeCapture: BarcodeCapture, didScanIn session: BarcodeCaptureSession, frameData: FrameData) {
		let recognizedBarcodes = session.newlyRecognizedBarcodes
		for barcode in recognizedBarcodes where barcode.symbology == .ean8 {
			DispatchQueue.main.async {
				self.ean8Code = barcode.data
			}
		}
	}
}
