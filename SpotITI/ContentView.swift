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
	
	@AppStorage("showWelcomeScreen") var showWelcomeScreen: Bool = true
	@AppStorage("utilityDisplayMode") var utilityDisplayMode: UtilityDisplayMode = .grouped
	
	var body: some View {
		ZStack {
			scannerView
			
			if navigationManager.isNavigating {
				compassView
			}
		}
		.sheet(isPresented: .constant(true)) {
			VStack {
				if showWelcomeScreen {
					WelcomeView()
				} else {
					mainContentView
				}
			}
				.presentationDetents(navigationManager.presentationDetents, selection: $navigationManager.selectedDetent)
				.presentationBackgroundInteraction(.enabled)
				.interactiveDismissDisabled(true)
				.presentationCornerRadius(25)
				.presentationDragIndicator(.hidden)
		}
		.task {
			do {
				// Fetch spots
				try await apiManager.getSpots()
				
				// Fetch utilities
				switch utilityDisplayMode {
					case .grouped:
						try await apiManager.getCategories()
					case .all:
						// Manage single spot fetch
						return
				}
			} catch {
				print(error.localizedDescription)
			}
		}
		.animation(.easeInOut, value: navigationManager.isNavigating)
		.animation(.easeOut, value: showWelcomeScreen)
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
