//
//  DevicesView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 15/03/23.
//

import SwiftUI
import CoreBluetooth

struct DevicesView: View {
	@ObservedObject private var bluetoothScanner = BluetoothScanner()
	@State var selectedDevice: DiscoveredPeripheral?
	@State private var searchText = ""
	
	var body: some View {
		NavigationStack {
			List(bluetoothScanner.discoveredPeripherals.filter {
				self.searchText.isEmpty ? true : $0.peripheral.name?.lowercased().contains(self.searchText.lowercased()) == true
			}, id: \.peripheral.identifier) { discoveredPeripheral in
				#if os(macOS)
				HStack {
					Text(discoveredPeripheral.peripheral.name ?? "Unknown Device")
					Text(discoveredPeripheral.RSSI.stringValue)
						.font(.caption)
						.foregroundColor(.gray)
				}
				.onTapGesture {
					selectedDevice = discoveredPeripheral
				}
				#else
				Button {
					selectedDevice = discoveredPeripheral
				} label: {
					VStack(alignment: .leading) {
						Text(discoveredPeripheral.peripheral.name ?? "Unknown Device")
						Text(discoveredPeripheral.RSSI.stringValue)
							.font(.caption)
							.foregroundColor(.gray)
					}
				}
				#endif
			}
			.listStyle(.automatic)
			.sheet(item: $selectedDevice) { device in
				if let deviceIndex = bluetoothScanner.discoveredPeripherals.firstIndex(where: { $0.id == device.id }) {
					DeviceDetailView(index: deviceIndex)
						.environmentObject(bluetoothScanner)
				}
			}
			.navigationTitle("Scanner")
			.searchable(text: $searchText)
			.toolbar {
				#if os(macOS)
				ToolbarItem(placement: .automatic) { scanButton }
				#else
				ToolbarItem(placement: .navigationBarTrailing) { scanButton }
				#endif
			}
		}
	}
	
	var scanButton: some View {
		Button(action: {
			if self.bluetoothScanner.isScanning {
				self.bluetoothScanner.stopScan()
			} else {
				self.bluetoothScanner.startScan()
			}
		}) {
			if bluetoothScanner.isScanning {
				Text("Stop Scanning")
			} else {
				Text("Scan for Devices")
			}
		}
	}
	
}

struct DevicesView_Previews: PreviewProvider {
	static var previews: some View {
		DevicesView()
	}
}

