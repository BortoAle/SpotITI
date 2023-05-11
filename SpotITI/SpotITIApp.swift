//
//  SpotITIApp.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 15/03/23.
//

import SwiftUI

@main
struct SpotITIApp: App {
	
	@StateObject var locationManager = LocationManager()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(locationManager)
		}
	}
}
