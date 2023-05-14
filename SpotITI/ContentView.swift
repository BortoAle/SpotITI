//
//  ContentView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI
import AVFoundation

// MARK: - ContentView

struct ContentView: View {
	@EnvironmentObject var navigationManager: NavigationManager
	@EnvironmentObject var scanManager: ScanManager

	@State var showCurrentPosition: Bool = true
	@State var debugActive: Bool = false
	
	// Body of the ContentView
	var body: some View {
		ZStack {
			scannerView
			compassView
		}
		.sheet(isPresented: .constant(true)) {
			navigationStackView
		}
		.onAppear {
			navigationManager.selectedMap = navigationManager.maps.first
		}
		.onChange(of: scanManager.ean8Code) { _ in
			playSoundAndHapticFeedback()
		}
		.task {
			navigationManager.maps = await navigationManager.fetchMaps()
		}
	}
}

// MARK: - Subviews and computed properties

extension ContentView {
	// ScannerView that covers the entire screen
	var scannerView: some View {
		ScannerView(scanner: scanManager)
			.ignoresSafeArea()
	}
	
	// CompassView on top of the screen
	var compassView: some View {
		CompassView()
			.offset(y: -120)
			.opacity(0.9)
	}
	
	// NavigationStackView as a sheet covering part of the screen
	var navigationStackView: some View {
		NavigationStack {
			if debugActive {
				Text(scanManager.ean8Code ?? "N/A")
			}
			
			// The main content of the navigation stack
			mainContentView
				.navigationTitle("Aule")
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						debugToolbarContent
					}
				}
				.navigationBarTitleDisplayMode(.inline)
		}
		.presentationDetents(navigationManager.presentationDetents, selection: $navigationManager.selectedDetent)
		.presentationBackgroundInteraction(.enabled)
		.interactiveDismissDisabled(true)
		.presentationCornerRadius(30)
		.presentationDragIndicator(.hidden)
	}
	
	// The main content of the NavigationStack
	@ViewBuilder
	var mainContentView: some View {
		switch navigationManager.currentView {
		case .home:
			ClassroomGridView()
				.searchable(text: .constant(""))
		case .detail:
			NavigationPreviewView()
		case .navigation:
			NavigationView()
		}
	}
	
	// Toolbar content for the debug mode
	var debugToolbarContent: some View {
		Button {
			debugActive.toggle()
		} label: {
			Image(systemName: "info.circle")
		}
	}
}

// MARK: - Functions

extension ContentView {
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

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(NavigationManager())
	}
}
