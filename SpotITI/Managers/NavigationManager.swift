//
//  QRCodeScanner.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI
import AVFoundation
import CoreMotion
import CoreLocation
import ScanditBarcodeCapture

class NavigationManager: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate {
	
	@Published var isNavigating: Bool = false
	var currentRoute: Route? = nil
	var currentVertexIndex: Int? = nil
	
	// Views properties
	@Published var currentView: ViewType = .home
	@Published var selectedDetent: PresentationDetent = .large
	@Published var presentationDetents: Set<PresentationDetent> = []
	
	// CompassViewModel properties
	@Published var rotation3D: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 0, 0)
	@Published var heading: Double = 0
	
	private var rotation: CLLocationDirection = 0
	private var filteredAcceleration: (x: Double, y: Double) = (0, 0)
	private let filterConstant: Double = 0.1
	private var locationManager: CLLocationManager
	private var motionManager: CMMotionManager
	
	override init() {
		
		// CompassViewModel setup
		locationManager = CLLocationManager()
		motionManager = CMMotionManager()
		super.init()
		
		setCurrentView(view: .home)
		
		// CLLocationManager setup
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation 
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
}

extension NavigationManager {
	
	func getCurrentVertex() throws -> Vertex {
		guard let vertices = currentRoute?.vertices, let index = currentVertexIndex else {
			throw SpotITIError.noVertexSet
		}
		return vertices[index]
	}
	
	func updatePosition(barCodeValue: Int) {
		updateCurrentVertexIndex(barcodeValue: barCodeValue)
		updateHeading()
	}
	
	func startNavigation(route: Route) async throws {
		currentRoute = route
		setCurrentView(view: .navigation)
		isNavigating = true
		playSoundAndHapticFeedback()
	}
	
	func stopNavigation() {
		isNavigating = false
		setCurrentView(view: .home)
	}
	
	func updateCurrentVertexIndex(barcodeValue: Int) {
		if let index = currentRoute?.vertices.firstIndex(where: { $0.id == barcodeValue }) {
			currentVertexIndex = index
		}
	}
	
	func updateHeading() {
		if let vertices = currentRoute?.vertices, let index = currentVertexIndex {

			guard index < vertices.count-1 else {
				return
			}
			
			let currentVertex = vertices[index]
			let nextVertex = vertices[index+1]
			
			rotation = directionBetweenPoints(
				current: CGPoint(x: Double(currentVertex.x), y: Double(currentVertex.y)),
				next: CGPoint(x: Double(nextVertex.x), y: Double(nextVertex.y))
			)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		DispatchQueue.main.async {
			withAnimation {
				#warning("rotazione anomala")
				self.heading = newHeading.trueHeading - self.rotation
			}
		}
	}
	
	func directionBetweenPoints(current: CGPoint, next: CGPoint) -> CLLocationDirection {
		let deltaX = next.x - current.x
		let deltaY = next.y - current.y
		print(current.x)
		print(next.x)
		print(current.y)
		print(next.y)
		let angleInRadians = atan2(deltaY, deltaX)
		let angleInDegrees = angleInRadians * 180 / .pi
		return angleInDegrees
		
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
	
}
