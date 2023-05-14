//
//  ClassroomListView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI
import AVFoundation

// MARK: - ClassroomGridView

struct ClassroomGridView: View {
	
	@EnvironmentObject private var navigationManager: NavigationManager
	@EnvironmentObject private var scanManager: ScanManager

	
	@State private var debugActive: Bool = false

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading) {
					utilitySection
					classroomsSection
				}
				.padding()
			}
				.navigationTitle("Aule")
				.navigationBarTitleDisplayMode(.inline)
				.searchable(text: .constant(""))
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						HStack {
							if debugActive {
								Text(scanManager.ean8Code ?? "N/A")
							}
							debugToolbarContent
						}
					}
				}
				.onChange(of: scanManager.ean8Code) { _ in
					playSoundAndHapticFeedback()
				}
		}
	}
	
	// Toolbar content for the debug mode
	var debugToolbarContent: some View {
		Button {
			debugActive.toggle()
		} label: {
			Image(systemName: "ladybug")
		}
	}
	
}

// MARK: - Subviews

extension ClassroomGridView {
	// Section for utilities
	var utilitySection: some View {
		VStack(alignment: .leading) {
			Text("Utilità")
				.font(.headline)
			LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))]) {
				UtilityCard(name: "Servizi Donne", emoji: "🚾")
				UtilityCard(name: "Servizi Uomini", emoji: "🚾")
				UtilityCard(name: "Presidenza", emoji: "👑")
				UtilityCard(name: "Ufficio Tecnico", emoji: "🛠️")
				UtilityCard(name: "Aula Magna", emoji: "🪑")
				UtilityCard(name: "Bidelleria", emoji: "🧹")
			}
		}
	}

	// Section for classrooms
	var classroomsSection: some View {
		VStack(alignment: .leading) {
			Text("Aule")
				.font(.headline)
			Text("A")
				.font(.subheadline)
				.foregroundColor(.secondary)
			LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
				ForEach(0..<11) { _ in
					ClassroomCard(name: "AB")
						.onTapGesture {
							navigationManager.setCurrentView(view: .detail)
						}
				}
			}
		}
	}
}

// MARK: - Functions

extension ClassroomGridView {
	// Play sound and haptic feedback when EAN8 code changes
	func playSoundAndHapticFeedback() {
		if debugActive {
			if let soundURL = Bundle.main.url(forResource: "beep", withExtension: "m4a") {
				var soundID: SystemSoundID = 0
				AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
				AudioServicesPlaySystemSound(soundID)
			}
			
			let generator = UIImpactFeedbackGenerator(style: .heavy)
			generator.impactOccurred()
		}
	}
}

// MARK: - PreviewProvider

struct ClassroomGridView_Previews: PreviewProvider {
	static var previews: some View {
		ClassroomGridView()
			.environmentObject(NavigationManager())
	}
}
