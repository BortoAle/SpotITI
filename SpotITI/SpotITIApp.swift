//
//  SpotITIApp.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 15/03/23.
//

import SwiftUI

@main
struct SpotITIApp: App {
	
	@StateObject var navigationManager = NavigationManager()
	@StateObject var scanManager = ScanManager()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(navigationManager)
				.environmentObject(scanManager)
		}
	}
}
