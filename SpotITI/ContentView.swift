//
//  ContentView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI

struct ContentView: View {
	
	@Environment(NavigationManager.self) private var navigationManager: NavigationManager
	@Environment(APIManager.self) private var apiManager: APIManager
	@Environment(ScanManager.self) var scanManager: ScanManager
	@Environment(AppScreen.self) var appScreen: AppScreen

	@AppStorage("showWelcomeScreen") var showWelcomeScreen: Bool = true
	@AppStorage("utilityDisplayMode") var utilityDisplayMode: UtilityDisplayMode = .grouped
	
	@State var selectedSpot: Spot?
	
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
			.presentationDetents(appScreen.presentationDetents, selection: Binding(get: {
				appScreen.selectedDetent
			}, set: { newValue in
				appScreen.selectedDetent = newValue
			}))
				.presentationBackgroundInteraction(.disabled)
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
		switch appScreen.currentView {
			case .home:
				HomeView(selectedSpot: $selectedSpot)
			case .navigationPreview:
				NavigationPreviewView(spot: selectedSpot!)
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

#Preview {
	ContentView()
		.environment(NavigationManager())
		.environment(ScanManager())
		.environment(APIManager())
		.environment(AppScreen())
}
