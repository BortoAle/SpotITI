//
//  QRCodeScanner.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import AVFoundation
import SwiftUI

class LocationManager: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
	
	let session = AVCaptureSession()
	
	@Published var maps: [Map] = []
	@Published var currentVertex: Vertex? = nil
	@Published var selectedMap: Map? = nil
	@Published var canReachServer: Bool = true
	@Published var currentView: ViewType = .home
	
	@Published var qrCodeValue: String = "" {
		didSet {
				updateCurrentVertex()
		}
	}
	
	func updateCurrentVertex() {
		if let selectedMap = maps.first {
			withAnimation(.easeInOut) {
				currentVertex = selectedMap.vertices.first(where: {
					$0.id.codingKey.stringValue == qrCodeValue
				})!
			}
		}
	}
	
//	func directionBetweenPoints(current: CGPoint, next: CGPoint) -> Double {
//		let deltaX = maps.x - current.x
//		let deltaY = next.y - current.y
//		let angleInRadians = atan2(deltaY, deltaX)
//		let angleInDegrees = angleInRadians * 180 / .pi
//		return angleInDegrees
//	}

	
}

//MARK: API
extension LocationManager {
	func fetchMaps() async -> [Map] {
		let url = URL(string: "http://192.168.1.2:3000/maps")!
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			let decodedData = try JSONDecoder().decode([Map].self, from: data)
			return decodedData
		} catch {
			canReachServer = false
			print(error.localizedDescription)
		}
		return []
	}
}

//MARK: Camera
extension LocationManager {
	
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
		output.metadataObjectTypes = [.microQR]
		
			self.session.startRunning()
	}
	
	func stopScanning() {
		session.stopRunning()
		UIApplication.shared.windows.first?.layer.sublayers?.removeLast()
	}
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject, object.type == .microQR, let stringValue = object.stringValue else { return }
		
		qrCodeValue = stringValue
	}
	
}
