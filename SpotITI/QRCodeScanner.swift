//
//  QRCodeScanner.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import AVFoundation
import SwiftUI

class QRCodeScanner: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
	let session = AVCaptureSession()
	@Published var qrCodeValue: String = ""

	func startScanning() {
		guard !session.isRunning else { return }

		let wideAngleCamera = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera, .builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
			guard let device = wideAngleCamera, let input = try? AVCaptureDeviceInput(device: device) else { return }


		if session.canAddInput(input) {
			session.addInput(input)
		}

		let output = AVCaptureMetadataOutput()
		if session.canAddOutput(output) {
			session.addOutput(output)
		}

		output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
		output.metadataObjectTypes = [.qr, .microQR]

		session.startRunning()
	}




	func stopScanning() {
		session.stopRunning()
		UIApplication.shared.windows.first?.layer.sublayers?.removeLast()
	}


	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject, object.type == .qr, let stringValue = object.stringValue else { return }

		qrCodeValue = stringValue
	}

}
