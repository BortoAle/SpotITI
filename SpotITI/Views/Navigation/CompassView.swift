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

struct CompassView: View {
	
	@EnvironmentObject private var navigationManager: NavigationManager
	
	@State private var backgroundColor = Color.primary
	@State private var hapticEngine: CHHapticEngine?
	@State private var isInsideDirection = false
	
	var body: some View {
		VStack {
			Image(systemName: "arrow.up")
				.resizable()
				.scaledToFit()
				.frame(height: 200)
				.fontWeight(.black)
				.foregroundColor(Color(uiColor: .secondarySystemBackground))
				.rotationEffect(.degrees(-navigationManager.heading))
				.rotation3DEffect(
					.degrees(navigationManager.rotation3D.x),
					axis: (x: 1, y: 0, z: 0),
					anchor: .center,
					anchorZ: 0.0,
					perspective: 0.5
				)
				.rotation3DEffect(
					.degrees(navigationManager.rotation3D.y),
					axis: (x: 0, y: 1, z: 0),
					anchor: .center,
					anchorZ: 0.0,
					perspective: 0.5
				)
				.foregroundColor(backgroundColor)
				.onReceive(navigationManager.$heading) { heading in
					if abs(heading) < 10 {
						if !isInsideDirection {
							isInsideDirection = true
							showDirectionFeedback()
						}
					} else {
						isInsideDirection = false
					}
				}
		}
	}
	
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
	
}
