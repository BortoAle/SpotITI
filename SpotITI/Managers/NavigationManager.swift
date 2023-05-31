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
	var currentNodeIndex: Int? = nil
	
	@Published var currentView: ViewType = .home
	@Published var selectedSpot: Spot? = nil
	@Published var selectedDetent: PresentationDetent = .large
	@Published var presentationDetents: Set<PresentationDetent> = []
	
	@Published var rotation3D: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 0, 0)
	@Published var heading: Double = 0
	
	private var rotation: CLLocationDirection = 0
	private var filteredAcceleration: (x: Double, y: Double) = (0, 0)
	private let filterConstant: Double = 0.1
	private var locationManager: CLLocationManager
	private var motionManager: CMMotionManager
	
	override init() {
		
		locationManager = CLLocationManager()
		motionManager = CMMotionManager()
		super.init()
		
		setCurrentView(view: .home)
		setUpLocationManager()
	}
	
	/// Starts navigation with a given Route
	///  - Parameter route: the navigation route
	func startNavigation(route: Route) {
		currentRoute = route
		currentNodeIndex = 0
		isNavigating = true
		setCurrentView(view: .navigation)
		playSoundAndHapticFeedback()
	}
	
	/// Stops navigation and returns to home screen
	func stopNavigation() {
		isNavigating = false
		currentRoute = nil
		currentNodeIndex = nil
		setCurrentView(view: .home)
	}
	
	/// Finds the new Node index in the Route nodes array given the Node id
	/// - Parameter barcodeValue: value read by the scanner
	func updatePosition(barcodeValue: Int) {
		guard let route = currentRoute, let nodeIndex = route.nodes.firstIndex(where: { $0.id == barcodeValue }), nodeIndex < route.lenght - 1 else {
			stopNavigation()
			return
		}
		currentNodeIndex = nodeIndex
		updateHeading()
	}
	
	/// Changes the sheet dimensions to fit the current view shown
	/// - Parameter view: the view type
	func setCurrentView(view: ViewType) {
		let viewToDetents: [ViewType: PresentationDetent] = [
			.home: .large,
			.navigationPreview: .fraction(0.35),
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

extension NavigationManager {
	
	private func updateHeading() {
		
		let current = currentRoute!.nodes[currentNodeIndex!]
		let next = currentRoute!.nodes[currentNodeIndex! + 1]
		
		let rotation = directionBetweenPoints(
			current: CGPoint(x: Double(current.x), y: Double(current.y)),
			next: CGPoint(x: Double(next.x), y: Double(next.y))
		)
		
		let smallestDifference = smallestAngle(from: heading, to: rotation)
		heading += smallestDifference
		
	}
	
	private func directionBetweenPoints(current: CGPoint, next: CGPoint) -> CLLocationDirection {
		let deltaX = next.x - current.x
		let deltaY = next.y - current.y
		
		let angleInRadians = atan2(deltaY, deltaX)
		let angleInDegrees = angleInRadians * 180 / .pi
		
		return angleInDegrees
	}
	
	private func smallestAngle(from angle1: Double, to angle2: Double) -> Double {
		let difference = angle2 - angle1
		let adjustedDifference = atan2(sin(difference * .pi / 180), cos(difference * .pi / 180))
		return adjustedDifference * 180 / .pi
	}
	
	private func setUpLocationManager() {
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
	
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		DispatchQueue.main.async {
			withAnimation {
				self.heading = newHeading.trueHeading - self.rotation
			}
		}
	}
	
}
