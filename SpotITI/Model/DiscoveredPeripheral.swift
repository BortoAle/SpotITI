//
//  DiscoveredPeripheral.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 17/03/23.
//

import CoreBluetooth

struct DiscoveredPeripheral: Identifiable {
		// Struct to represent a discovered peripheral
		let id = UUID()
		var peripheral: CBPeripheral
		var advertisedData: String
		var RSSI: NSNumber
}
