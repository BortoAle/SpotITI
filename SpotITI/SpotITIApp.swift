//
//  SpotITIApp.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 15/03/23.
//

import SwiftUI

@main
struct SpotITIApp: App {
	
	@State private var navigationManager = NavigationManager()
	@State private var scanManager = ScanManager()
	@State private var apiManager = APIManager()
    @State private var appScreen = AppScreen()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(navigationManager)
				.environment(scanManager)
				.environment(apiManager)
                .environment(appScreen)
		}
	}
}
