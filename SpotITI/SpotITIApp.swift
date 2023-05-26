//
//  SpotITIApp.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 15/03/23.
//

import SwiftUI

@main
struct SpotITIApp: App {
	
	@StateObject private var navigationManager = NavigationManager()
	@StateObject private var scanManager = ScanManager()
	@StateObject private var apiManager = APIManager()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(navigationManager)
				.environmentObject(scanManager)
				.environmentObject(apiManager)
		}
	}
}
