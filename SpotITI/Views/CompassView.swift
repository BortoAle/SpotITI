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
	
	@Environment(NavigationManager.self) private var navigationManager: NavigationManager

	@State private var hapticEngine: CHHapticEngine?
	
	let width = UIScreen.main.bounds.width
	
	var body: some View {
		VStack {
			Image(systemName: "arrow.up")
				.resizable()
				.scaledToFit()
				.frame(width: width/2)
				.fontWeight(.black)
				.foregroundStyle(Color(uiColor: .secondarySystemBackground))
				.rotationEffect(.degrees(navigationManager.heading))
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
				.foregroundStyle(Color(uiColor: .systemBackground))
		}
	}
}

#Preview {
	CompassView()
		.previewLayout(.sizeThatFits)
		.environment(NavigationManager())
}
