//
//  QRCodeScanner.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import AVFoundation
import SwiftUI
import ScanditBarcodeCapture
import CoreMotion
import CoreLocation
import Combine

class NavigationManager: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate {
	
	@Published var maps: [Map] = []
	@Published var currentVertex: Vertex? = nil
	@Published var selectedMap: Map? = nil
	@Published var canReachServer: Bool = true
	@Published var currentView: ViewType = .home
	@Published var isNavigating: Bool = false
	
	@Published var selectedDetent: PresentationDetent = .large
	@Published var presentationDetents: Set<PresentationDetent> = []
	
	// CompassViewModel properties
	@Published var heading: Double = 0
	@Published var rotation3D: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 0, 0)
	private var filteredAcceleration: (x: Double, y: Double) = (0, 0)
	private let filterConstant: Double = 0.1
	private var locationManager: CLLocationManager
	private var motionManager: CMMotionManager
	
	var cancellable : AnyCancellable?
		
		func connect(_ publisher: AnyPublisher<String?,Never>) {
			cancellable = publisher.sink(receiveValue: { (newString) in
				self.barcodeValue = newString
			})
		}
	@Published var barcodeValue: String? {
		didSet {
			currentVertex = selectedMap?.vertices.first(where: { $0.id.codingKey.stringValue == barcodeValue })
		}
	}
	
	func startNavigation() {
		isNavigating = true
		playSoundAndHapticFeedback()
	}
	
	func stopNavigation() {
		isNavigating = false
	}
	
	func setCurrentView(view: ViewType) {
		let viewToDetents: [ViewType: PresentationDetent] = [
			.home: .large,
			.detail: .fraction(0.35),
			.navigation: .fraction(0.2)
		]
		
		guard let detent = viewToDetents[view] else { return }
		
		presentationDetents = [.large, .fraction(0.35), .fraction(0.2)]
		currentView = view
		selectedDetent = detent
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.presentationDetents = [detent]
		}
	}

	
	override init() {
		
		// CompassViewModel setup
		locationManager = CLLocationManager()
		motionManager = CMMotionManager()
		super.init()
		
		setCurrentView(view: .home)
		
		// CLLocationManager setup
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingHeading()
		
		if motionManager.isAccelerometerAvailable {
			motionManager.accelerometerUpdateInterval = 1 / 60
			motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
				guard let self = self, let data = data else { return }
				
				// Apply low-pass filter to the accelerometer data
				let filteredX = data.acceleration.x * self.filterConstant + self.filteredAcceleration.x * (1 - self.filterConstant)
				let filteredY = data.acceleration.y * self.filterConstant + self.filteredAcceleration.y * (1 - self.filterConstant)
				self.filteredAcceleration = (x: filteredX, y: filteredY)
				
				let rotationX = -CGFloat(filteredY) * 90
				let rotationY = CGFloat(filteredX) * 90
				
				// Clamping the rotation values
				let clampedRotationX = min(max(rotationX, -70), 70)
				let clampedRotationY = min(max(rotationY, -70), 70)
				
				self.rotation3D.x = clampedRotationX
				self.rotation3D.y = clampedRotationY
			}
		}
	}
	
//		func updateCurrentVertex() {
//			if let selectedMap = maps.first {
//				withAnimation(.easeInOut) {
//					currentVertex = selectedMap.vertices.first(where: {
//						$0.id.codingKey.stringValue == qrCodeValue
//					})!
//				}
//			}
//		}
//	
	func directionBetweenPoints(current: CGPoint, next: CGPoint) -> Double {
		let deltaX = next.x - current.x
		let deltaY = next.y - current.y
		let angleInRadians = atan2(deltaY, deltaX)
		let angleInDegrees = angleInRadians * 180 / .pi
		return angleInDegrees
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		DispatchQueue.main.async {
			self.heading = newHeading.trueHeading
		}
	}
	
	func playSoundAndHapticFeedback() {
			if let soundURL = Bundle.main.url(forResource: "confirm", withExtension: "m4a") {
				var soundID: SystemSoundID = 0
				AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
				AudioServicesPlaySystemSound(soundID)
			}
			
		let generator = UIImpactFeedbackGenerator(style: .heavy)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			for i in 0..<3 {
				DispatchQueue.main.asyncAfter(deadline: .now() + (0.2 * Double(i))) {
					generator.impactOccurred()
				}
			}
		}

		
	}
	
}
