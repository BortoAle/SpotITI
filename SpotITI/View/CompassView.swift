//
//  CompassView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 27/04/23.
//

import SwiftUI
import CoreLocation
import CoreMotion
import AVFoundation
import CoreHaptics

class CompassViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var heading: Double = 0
	@Published var rotation3D: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 0, 0)
	
	private var filteredAcceleration: (x: Double, y: Double) = (0, 0)

		// Low-pass filter constant (adjust this value to change the filter strength, between 0 and 1)
		private let filterConstant: Double = 0.1
	
	private var locationManager: CLLocationManager
	private var motionManager: CMMotionManager

	override init() {
		locationManager = CLLocationManager()
		motionManager = CMMotionManager()
		super.init()
		
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

	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		DispatchQueue.main.async {
			self.heading = newHeading.trueHeading
		}
	}
}

struct CompassView: View {
	@StateObject private var viewModel = CompassViewModel()
	@State private var backgroundColor = Color.primary
	@State private var hapticEngine: CHHapticEngine?
	@State private var isInsideDirection = false


	private func playHapticFeedback() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

		do {
			hapticEngine = try CHHapticEngine()
			try hapticEngine?.start()

			let hapticEvent = try CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
			let pattern = try CHHapticPattern(events: [hapticEvent], parameters: [])
			let player = try hapticEngine?.makePlayer(with: pattern)
			try player?.start(atTime: CHHapticTimeImmediate)
		} catch {
			print("Error playing haptic feedback: \(error)")
		}
	}

	private func showDirectionFeedback() {
		backgroundColor = Color.green
		playHapticFeedback()

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.backgroundColor = Color.primary
		}
	}


	var body: some View {
		VStack {
			Image(systemName: "arrow.up") // Replace "north_arrow" with your image asset name
				.resizable()
				.scaledToFit()
				.frame(width: 130)
				.fontWeight(.black)
				.rotationEffect(.degrees(-viewModel.heading))
				.rotation3DEffect(
					.degrees(viewModel.rotation3D.x),
					axis: (x: 1, y: 0, z: 0),
					anchor: .center,
					anchorZ: 0.0,
					perspective: 0.5
				)
				.rotation3DEffect(
					.degrees(viewModel.rotation3D.y),
					axis: (x: 0, y: 1, z: 0),
					anchor: .center,
					anchorZ: 0.0,
					perspective: 0.5
				)
				.foregroundColor(backgroundColor)
					.onReceive(viewModel.$heading) { heading in
						if abs(heading) < 10 { // Change this condition to match the desired direction
									if !isInsideDirection {
										isInsideDirection = true
										showDirectionFeedback()
									}
								} else {
									isInsideDirection = false
								}
					}
					.frame(maxHeight: .infinity, alignment: .center)
		}
	}
}
