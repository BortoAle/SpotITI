//
//  DeviceDetailView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 16/03/23.
//

import SwiftUI

struct DeviceDetailView: View {
	
	@EnvironmentObject var bluetoothScanner: BluetoothScanner
	let index: Int
	
	var device: DiscoveredPeripheral {
		bluetoothScanner.discoveredPeripherals[index]
	}
	
    var body: some View {
			VStack {
				Text(device.peripheral.name ?? "Unknown")
				Text(device.RSSI.stringValue)
			}
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
			DeviceDetailView(index: 1)
				.environmentObject(BluetoothScanner())
    }
}
