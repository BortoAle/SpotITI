//
//  ContentView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
	@EnvironmentObject private var navigationManager: NavigationManager
	@EnvironmentObject var scanManager: ScanManager
	
	let apiManager = APIManager()
	
	@State private var showCurrentPosition: Bool = true
	
	// Body of the ContentView
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
		.onAppear {
//			navigationManager.selectedMap = navigationManager.maps.first
			navigationManager.maps = [Map.map1]
			navigationManager.selectedMap = Map.map1
			navigationManager.connect(scanManager.$ean8Code.eraseToAnyPublisher())
		}
		.task {
//			navigationManager.maps = await apiManager.fetchMaps()
		}
		.animation(.easeInOut, value: navigationManager.isNavigating)
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
	
	// The main content of the NavigationStack
	@ViewBuilder
	var mainContentView: some View {
		switch navigationManager.currentView {
			case .home:
				ClassroomGridView()
			case .detail:
				NavigationPreviewView()
			case .navigation:
				NavigationView()
		}
	}
	
}

// MARK: - PreviewProvider

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(NavigationManager())
			.environmentObject(ScanManager())
	}
}
