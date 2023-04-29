//
//  SpotITIApp.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 15/03/23.
//

import SwiftUI

@main
struct SpotITIApp: App {
	
	@ObservedObject private var bluetoothScanner = BluetoothScanner()
	
	var body: some Scene {
		WindowGroup {
			QRScannerView()
//			CompassView()
//			DeviceListView()
//				.frame(minWidth: 800, minHeight: 600)
//				.environmentObject(bluetoothScanner)
		}
	}
}
