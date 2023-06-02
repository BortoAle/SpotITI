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
	
	@Published var ean8Code: Int?
	
	override init() {
		
		// API key load from plist
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
		let cameraSettings = CameraSettings()
		cameraSettings.focusRange = .far
		cameraSettings.macroMode = .off
		cameraSettings.preferredResolution = .hd
		cameraSettings.focusGestureStrategy = .none
		
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
		
		barcodeCapture.feedback.success = Feedback(vibration: nil,sound: .none)
		
		// Scart scanning
		barcodeCapture.isEnabled = true
	}
}

extension ScanManager: BarcodeCaptureListener {

	func barcodeCapture(_ barcodeCapture: BarcodeCapture, didScanIn session: BarcodeCaptureSession, frameData: FrameData) {
		let recognizedBarcodes = session.newlyRecognizedBarcodes
		for barcode in recognizedBarcodes where barcode.symbology == .ean8 {
			DispatchQueue.main.async {
				if let data = barcode.data {
					// Id update
					self.ean8Code = Int(data)
				}
			}
		}
		// Disable capturing after a capture
		barcodeCapture.isEnabled = false
		// Re-enable capture after 1 second
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			barcodeCapture.isEnabled = true
		}
	}
}
