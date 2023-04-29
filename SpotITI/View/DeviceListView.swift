//
//  DeviceListView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 15/03/23.
//

import SwiftUI
import CoreBluetooth

struct DeviceListView: View {
	
	@EnvironmentObject var bluetoothScanner: BluetoothScanner
	@State var selectedDevice: DiscoveredPeripheral?
	@State private var searchText = ""
	
	var body: some View {
		NavigationStack {
			List(bluetoothScanner.discoveredPeripherals.filter {
				self.searchText.isEmpty ? true : $0.peripheral.identifier.uuidString.lowercased().contains(self.searchText.lowercased()) == true 
			}, id: \.peripheral.identifier) { discoveredPeripheral in
				#if os(macOS)
				VStack(alignment: .leading, spacing: 4) {
					Text(discoveredPeripheral.peripheral.name ?? "Unknown Device")
						.font(.headline)
						.foregroundColor(.primary)
					Text(discoveredPeripheral.peripheral.identifier.uuidString)
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
					VStack(alignment: .leading, spacing: 4) {
						Text(discoveredPeripheral.peripheral.name ?? "Unknown Device")
							.font(.headline)
							.foregroundColor(.primary)
						Text(discoveredPeripheral.peripheral.identifier.uuidString)
							.font(.caption)
							.foregroundColor(.gray)
					}
				}
				.padding(.vertical, 4)
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
				HStack {
					Text("Stop")
					Image(systemName: "antenna.radiowaves.left.and.right.slash")
				}
			} else {
				HStack {
					Text("Start")
					Image(systemName: "antenna.radiowaves.left.and.right")
				}
			}
		}
		.buttonStyle(.borderedProminent)
	}
	
}

struct DeviceListView_Previews: PreviewProvider {
	static var previews: some View {
		DeviceListView()
	}
}

