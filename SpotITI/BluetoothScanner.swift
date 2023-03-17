//
//  BLEScanner.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 16/03/23.
//

import SwiftUI
import CoreBluetooth

class BluetoothScanner: NSObject, CBCentralManagerDelegate, ObservableObject {
		@Published var discoveredPeripherals = [DiscoveredPeripheral]()
		@Published var isScanning = false
		var centralManager: CBCentralManager!
		// Set to store unique peripherals that have been discovered
		var discoveredPeripheralSet = Set<CBPeripheral>()
		var timer: Timer?

		override init() {
				super.init()
				centralManager = CBCentralManager(delegate: self, queue: nil)
		}

		func startScan() {
				if centralManager.state == .poweredOn {
						// Set isScanning to true and clear the discovered peripherals list
						isScanning = true
						discoveredPeripherals.removeAll()
						discoveredPeripheralSet.removeAll()
						objectWillChange.send()

						// Start scanning for peripherals
						centralManager.scanForPeripherals(withServices: nil)

						// Start a timer to stop and restart the scan every 2 seconds
						timer?.invalidate()
						timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { [weak self] timer in
								self?.centralManager.stopScan()
								self?.centralManager.scanForPeripherals(withServices: nil)
						}
				}
		}

		func stopScan() {
				// Set isScanning to false and stop the timer
				isScanning = false
				timer?.invalidate()
				centralManager.stopScan()
		}

		func centralManagerDidUpdateState(_ central: CBCentralManager) {
				switch central.state {
				case .unknown:
						//print("central.state is .unknown")
						stopScan()
				case .resetting:
						//print("central.state is .resetting")
						stopScan()
				case .unsupported:
						//print("central.state is .unsupported")
						stopScan()
				case .unauthorized:
						//print("central.state is .unauthorized")
						stopScan()
				case .poweredOff:
						//print("central.state is .poweredOff")
						stopScan()
				case .poweredOn:
						//print("central.state is .poweredOn")
						startScan()
				@unknown default:
						print("central.state is unknown")
				}
		}

		func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
			
			//Check if the name is known
//			if peripheral.name != nil {
				// If the peripheral is not already in the list
				if !discoveredPeripheralSet.contains(peripheral) {
						// Add it to the list and the set
					discoveredPeripherals.append(DiscoveredPeripheral(peripheral: peripheral, RSSI: RSSI))
						discoveredPeripheralSet.insert(peripheral)
				} else {
						// If the peripheral is already in the list, update its advertised data
						if let index = discoveredPeripherals.firstIndex(where: { $0.peripheral == peripheral }) {
								discoveredPeripherals[index].RSSI = RSSI
						}
				}
//			}
		}
}

