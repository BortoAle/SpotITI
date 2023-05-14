//
//  Utils.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 14/05/23.
//

import AVFoundation
import UIKit

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
