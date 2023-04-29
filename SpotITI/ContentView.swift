//
//  ContentView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI

struct ContentView: View {
	
	@State var showNavigationView: Bool = true
	
	
    var body: some View {
		VStack {
			CompassView()
//			QRScannerView()
			MapView()
		}
		.sheet(isPresented: $showNavigationView) {
			List() {
				ForEach(0..<3) { i in
					Text("Item \(i)")
				}
			}
			.presentationDetents([.medium, .large])
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
