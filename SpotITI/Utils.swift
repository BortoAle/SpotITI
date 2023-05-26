//
//  Utils.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 14/05/23.
//

import AVFoundation
import SwiftUI

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

struct DisableIdleTimer: ViewModifier {
	let disable: Bool

	func body(content: Content) -> some View {
		content
			.onAppear {
				UIApplication.shared.isIdleTimerDisabled = disable
			}
			.onDisappear {
				UIApplication.shared.isIdleTimerDisabled = false
			}
	}
}

extension View {
	func disableIdleTimer(_ disable: Bool) -> some View {
		self.modifier(DisableIdleTimer(disable: disable))
	}
}

