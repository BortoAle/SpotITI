//
//  ScanditEAN8Scanner.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 13/05/23.
//

import ScanditBarcodeCapture
import ScanditCaptureCore

class ScanManager: NSObject, ObservableObject {

	var dataCaptureContext: DataCaptureContext
	var barcodeCapture: BarcodeCapture
	 var camera: Camera?
	
	@Published var ean8Code: String?

	override init() {
		
		guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
			  let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
			  let apiKey = dict["API_KEY"] as? String else {
			fatalError("Failed to load API key")
		}

		dataCaptureContext = DataCaptureContext(licenseKey: apiKey)
		
		// Configura le impostazioni di scansione
		let settings = BarcodeCaptureSettings()
		settings.set(symbology: .ean8, enabled: true)
		barcodeCapture = BarcodeCapture(context: dataCaptureContext, settings: settings)
		
		// Configura la fotocamera
		let cameraSettings = BarcodeCapture.recommendedCameraSettings
		camera = Camera.default
		camera?.apply(cameraSettings)
		dataCaptureContext.setFrameSource(camera, completionHandler: nil)
		camera?.switch(toDesiredState: .on)
		
		super.init()
		
		// Aggiungi questo oggetto come listener
		barcodeCapture.addListener(self)
		
		// Crea la vista di acquisizione dati
		let captureView = DataCaptureView(context: dataCaptureContext, frame: .zero)
		
		// Crea e aggiungi l'overlay
		let overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture)
		captureView.addOverlay(overlay)
		
		// Inizia la scansione
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
