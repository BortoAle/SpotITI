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
	
	// Determines if navigation is active or not
	@Published var isNavigating: Bool = false
	
	// The spot selected by the user
	@Published var selectedSpot: Spot? = nil
	
	// The current active route for navigation
	var currentRoute: Route? = nil
	
	// Index for current node in the route
	var currentNodeIndex: Int? = nil
	
	// Sheet dimension management
	@Published var currentView: ViewType = .home
	@Published var selectedDetent: PresentationDetent = .large
	@Published var presentationDetents: Set<PresentationDetent> = []
	
	// 3D rotation values for the user compass
	@Published var rotation3D: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 0, 0)
	
	// 2D rotation of the compass
	@Published var heading: Double = 0
	
	// Other properties related to the device's motion and location tracking
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
	
	/// Initiates the navigation with the given route.
	///
	/// This method is used to start the navigation process. It assigns the provided route as the `currentRoute`,
	/// sets the `currentNodeIndex` to the starting point (0), and changes the `isNavigating` boolean to `true`.
	/// It also sets the current view to the navigation view and triggers sound and haptic feedback.
	///
	/// - Parameter route: The route object to be followed during the navigation.
	func startNavigation(route: Route) {
		currentRoute = route
		currentNodeIndex = 0
		isNavigating = true
		setCurrentView(view: .navigation)
		playSoundAndHapticFeedback()
	}
	
	/// Stops the navigation process and returns to the home screen.
	///
	/// This method is used to stop the navigation process. It resets the `currentRoute` and `currentNodeIndex` to `nil`,
	/// sets the `isNavigating` boolean to `false`, and changes the current view to the home screen.
	func stopNavigation() {
		isNavigating = false
		currentRoute = nil
		currentNodeIndex = nil
		setCurrentView(view: .home)
	}
	
	/// Updates the current position in the navigation route using the scanned barcode value.
	///
	/// This method is used to find the new Node index in the Route nodes array given the Node id (which is represented by the barcode value).
	/// It ensures that the scanned barcode value corresponds to a valid node in the current route and that it's not the last node of the route.
	/// If these conditions are met, it plays sound and haptic feedback, updates the `currentNodeIndex` and the heading.
	/// If not, it stops the navigation.
	///
	/// - Parameter barcodeValue: The barcode value that was scanned, representing a node id in the current route.
	func updatePosition(barcodeValue: Int) {
		guard let route = currentRoute, let nodeIndex = route.nodes.firstIndex(where: { $0.id == barcodeValue }), nodeIndex < route.lenght - 1 else {
			stopNavigation()
			return
		}
		playSoundAndHapticFeedback()
		currentNodeIndex = nodeIndex
		updateHeading()
	}
	
	/// Adjusts the size of the view sheet to match the size requirements of the current view.
	///
	/// This method is used to set the current view to a specified view type, and adjusts the size of the sheet
	/// to fit that view type. The size is defined by the detent associated with the specified view type.
	///
	/// - Parameter view: The view type that should be set as the current view.
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
	
	/// Updates the heading of the current navigation path.
	///
	/// This method calculates the direction between the current node and the next node in the route,
	/// determines the smallest difference between the current heading and this direction, and then
	/// updates the heading by this smallest difference.
	///
	/// This method should be called whenever the current position in the route updates.
	///
	/// - Note: This method assumes the existence of a 'next' node in the route.
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
	
	/// Returns the direction from a current point to a next point.
	///
	/// This method calculates the difference in X and Y coordinates between two points,
	/// then uses these differences to compute an angle in degrees. The angle represents
	/// the direction from the current point to the next point.
	///
	/// - Parameters:
	///   - current: The current point as a `CGPoint`.
	///   - next: The next point as a `CGPoint`.
	///
	/// - Returns: The direction from the current point to the next point, in degrees.
	private func directionBetweenPoints(current: CGPoint, next: CGPoint) -> CLLocationDirection {
		let deltaX = next.x - current.x
		let deltaY = next.y - current.y
		
		let angleInRadians = atan2(deltaY, deltaX)
		let angleInDegrees = angleInRadians * 180 / .pi
		
		return angleInDegrees
	}
	
	/// Returns the smallest angle (in degrees) between two given angles.
	///
	/// The method calculates the difference between two angles and adjusts the result to ensure
	/// it represents the smallest possible angle. This is done using the `atan2` function which
	/// takes into account the quadrant of the resulting vector (thus considering the direction
	/// of rotation). The result is then converted back to degrees.
	///
	/// - Parameters:
	///   - angle1: The first angle in degrees.
	///   - angle2: The second angle in degrees.
	///
	/// - Returns: The smallest difference between the two angles in degrees.
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
