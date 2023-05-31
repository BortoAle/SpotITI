//
//  ContentView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI

struct ContentView: View {
	
	@EnvironmentObject private var navigationManager: NavigationManager
	@EnvironmentObject private var apiManager: APIManager
	@EnvironmentObject var scanManager: ScanManager
	
	var body: some View {
		ZStack {
			scannerView
			
			if navigationManager.isNavigating {
				compassView
			}
		}
		.sheet(isPresented: .constant(true)) {
			mainContentView
				.presentationDetents(navigationManager.presentationDetents, selection: $navigationManager.selectedDetent)
				.presentationBackgroundInteraction(.enabled)
				.interactiveDismissDisabled(true)
				.presentationCornerRadius(25)
				.presentationDragIndicator(.hidden)
		}
		.animation(.easeInOut, value: navigationManager.isNavigating)
	}
	
	// The main content of the NavigationStack
	@ViewBuilder
	var mainContentView: some View {
		switch navigationManager.currentView {
			case .home:
				HomeView()
			case .navigationPreview:
				#warning("using mockup")
				NavigationPreviewView(spot: Spot.mockup)
			case .navigation:
				NavigationView()
		}
	}

	// ScannerView that covers the entire screen
	var scannerView: some View {
		ScannerView(scanner: scanManager)
			.ignoresSafeArea()
	}
	
	// CompassView on top of the screen
	var compassView: some View {
		CompassView()
			.opacity(0.9)
	}
	
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(NavigationManager())
			.environmentObject(ScanManager())
			.environmentObject(APIManager())
	}
}
