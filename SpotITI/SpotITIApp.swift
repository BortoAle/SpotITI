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
            DevicesView()
				.environmentObject(bluetoothScanner)
        }
    }
}
