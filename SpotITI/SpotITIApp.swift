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
	@StateObject var scanner = ScanditEAN8Scanner()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(locationManager)
				.environmentObject(scanner)
		}
	}
}
