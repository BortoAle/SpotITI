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
	@Published var selectedSpot: Spot?
	
	// The current active route for navigation
	var currentRoute: Route?
	
	var currentNode: Node? {
		didSet {
			updateNextNode()
		}
	}
	var nextNode: Node?
	
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
		currentNode = route.nodes.first
		updateHeading()
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
		currentNode = nil
		nextNode = nil
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
		print("barcode: \(barcodeValue)")
		guard let route = currentRoute, let node = route.nodes.first(where: { $0.id == barcodeValue }) else {
			stopNavigation()
			return
			}
		playSoundAndHapticFeedback()
		currentNode = node
		print("current \(currentNode!.id)")
		print("next \(nextNode!.id)")
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
	
	private func updateNextNode() {
		guard let route = currentRoute, let currentNode = currentNode, let currentIndex = route.nodes.firstIndex(of: currentNode) else {
			nextNode = nil
			return
		}
		
		let nextIndex = currentIndex + 1
		if nextIndex < route.nodes.count {
			nextNode = route.nodes[nextIndex]
		} else {
			// We're at the last node, so there's no next node
			stopNavigation()
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
		guard let currentNode = self.currentNode, let nextNode = self.nextNode else {
			fatalError("Problemino")
			return
		}
		
		let rotation = directionBetweenPoints(
			current: CGPoint(x: Double(currentNode.x), y: Double(currentNode.y)),
			next: CGPoint(x: Double(nextNode.x), y: Double(nextNode.y))
		)
		
		self.rotation = rotation
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
		let deltaY = -next.y + current.y
		
		print("deltaX: \(deltaX), deltaY: \(deltaY)")
		
		// atan2(x, y) gives the angle in radians between the y-axis and the point (x, y)
		let angleInRadians = atan2(deltaX, deltaY)
		
		// Convert radians to degrees because CLLocationDirection is in degrees
		let angleInDegrees = angleInRadians * 180 / .pi
		
		print("rotation \(angleInDegrees)")
		
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
		
		// atan2(sin(difference), cos(difference)) normalizes the angle difference to the range -π to π (-180 to 180 degrees)
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
				let newRotation = -newHeading.trueHeading + self.rotation + 45
				self.heading += self.smallestAngle(from: self.heading, to: newRotation)
			}
		}
	}
	
}
