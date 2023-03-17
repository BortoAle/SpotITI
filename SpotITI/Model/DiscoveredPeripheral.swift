//
//  DiscoveredPeripheral.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 17/03/23.
//

import CoreBluetooth

struct DiscoveredPeripheral: Identifiable {
		let id = UUID()
		var peripheral: CBPeripheral
		var RSSI: NSNumber
}
