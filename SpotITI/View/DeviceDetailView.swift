//
//  DeviceDetailView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 16/03/23.
//

import SwiftUI
import CoreBluetooth

struct DeviceDetailView: View {
	
	@EnvironmentObject var bluetoothScanner: BluetoothScanner
	let index: Int
	
	@State var bgColor: Color = .white
	@State var timer: Timer?
	
	var device: DiscoveredPeripheral {
		bluetoothScanner.discoveredPeripherals[index]
	}
	
	var body: some View {
		VStack {
			Text(bluetoothScanner.discoveredPeripherals[index].peripheral.name ?? "N/A")
				.font(.title2)
			Text("\(bluetoothScanner.discoveredPeripherals[index].RSSI)")
				.font(.largeTitle)
				.bold()
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background( bgColor )
		.animation(.easeInOut, value: bgColor)
		. onAppear {
			startTimer()
		}
		.onDisappear {
			stopTimer()
		}
	}

	func startTimer() {
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			//Update background on timer expire
			updateBackgroundColor()
		}
	}
	
	func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	private func updateBackgroundColor() {
		switch bluetoothScanner.discoveredPeripherals[index].RSSI.intValue {
			case let rssi where rssi < -60:
				bgColor = Color.orange
			case let rssi where rssi < -90:
				bgColor = Color.red
			default:
				bgColor = Color.green
		}
	}
}

//struct DeviceDetailView_Previews: PreviewProvider {
//
//	static var bluetoothScanner = BluetoothScanner()
//
//    static var previews: some View {
//			DeviceDetailView(index: )
//				.environmentObject(bluetoothScanner)
//    }
//}
