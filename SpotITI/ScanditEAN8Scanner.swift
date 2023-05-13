//
//  ScanditEAN8Scanner.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 13/05/23.
//

import ScanditBarcodeCapture
import ScanditCaptureCore

import ScanditBarcodeCapture
import ScanditCaptureCore

class ScanditEAN8Scanner: NSObject, ObservableObject {

	var dataCaptureContext: DataCaptureContext
	var barcodeCapture: BarcodeCapture
	var camera: Camera?
	
	@Published var ean8Code: String?

	override init() {
		// Inserisci la tua chiave di licenza Scandit
		dataCaptureContext = DataCaptureContext(licenseKey: "AeNDU2KKQaHrGTtVRzWc5yIXcjRVLvW9CDqBP0sGDOSTZuGCExXgUN8KRrStSo+VolAGgLIp8SBNXgdRP2mstW1JS2OmVpGADjXBjTwvme37HbHQrFhlU44rq3NKUcBUOWzu9EByUR5TdR4JsEypHKBL9N+Ocuv+YlgaxGxcv0Qqb9nIVGp3/M9EPe6XW/UKIEN30I51QYpBTaCm3CzABBd7quEsX1guH0go6gd6dcc1Quk2EUOFIixzLMtGeiNg7kLgSqVpsL21ZHnXCjBI7JBNN4tnSih+pnbZiBpi7TVfIyUqx3raENB5rsiMRaxs0F/SYkxpnhtpZOUv+3zWOf9GCZTTd7i0Li4WsftmvKqEXzQsPVjjNUp3G1dNQLafKGySEKMsfzd/bxJeH1qLkjNiFDeBWKjF1nfwF1p/CYBpTfy9eiBw/lpQLh8ISlVX3HG6YXxgh9VnLr46eVLPmzF/fahOD4O9DHvoH0ZTfBjqfKfl+3kPW65+jncQZ3WsFX4RBEpXyca8aT3bQADCuv5Fj+/BBPapZyMXM6gu2G8ID4gRuB44aUMPsATKVe+E/DqsYGP9sgOWfMmOWIKNjyQ424tSB6bay0S1bTxkce2iDks5dc8KuL5skniNIxIL0Mnqk0hdsrZjCMNOfOM3T2nUx1kMTg22T09UO40tyT5wG+br9OxgPnGF6EXrq0tfifV4m9mdfYgmdOMbPxKlHQGF7yQDS6bxEYt1r8JESeYVqM2dKPFQZKQgJj69I9v20C8tZOVCoDHx/HU5fr/Zq/3dAGKrMYhcZ5TPMjKs8xztoFLA8J0z04rpIWFvZNGFpCsOd+XYH9DLjMsvaSz2i6NayyweLmiUJJbL3l/UqcNt5az9Njp2zg6ElFPhfaRJt1wyCrcXcx2wAVunkz7l8kO36rXTR4wTbi7Gut5A+XPWCv1C6FlV3Y6+ulpsKLYBWwZWVWVx6RmCus8j7QgsJxnzDRE3OSTlODUdADCgbV9F1ugoPvg+jRvoRa6KdjKGz6VtO+UyqqF3npARnWcVuENAWDraH4DGYeS7J2h3YxsvdVClPowt2uGpfeRU7mA3oCxoSySwNTHfL6D/OUfd5di3avk1VUwF/iK5AVYi6qL1p7mDGeoW2edHYhGz80ypw6g92KYRbDOReyUmVLqB3P5acfJTTMtFXKEO/+WetWPAPs4xxZul35CEOFqBGhYYlpDvgNQaFG7STiH88xmfBag0snXDmpc=")
		
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

extension ScanditEAN8Scanner: BarcodeCaptureListener {
	
	func barcodeCapture(_ barcodeCapture: BarcodeCapture, didScanIn session: BarcodeCaptureSession, frameData: FrameData) {
		let recognizedBarcodes = session.newlyRecognizedBarcodes
		for barcode in recognizedBarcodes where barcode.symbology == .ean8 {
			DispatchQueue.main.async {
				self.ean8Code = barcode.data
			}
		}
	}
}
