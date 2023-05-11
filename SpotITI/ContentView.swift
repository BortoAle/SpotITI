//
//  ContentView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI

struct ContentView: View {
	
	@State var showNavigationView: Bool = true
	@EnvironmentObject var locationManager: LocationManager
	
	
	var body: some View {
		ZStack {
			
			CameraPreviewView(session: locationManager.session)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.ignoresSafeArea()
				.opacity(0.2)
			
			if locationManager.currentVertex != nil {
				CompassView()
					.sheet(isPresented: $showNavigationView) {
						NavigationStack {
							List() {
								ForEach(0..<3) { i in
									ClassroomCard(name: "AB", seats: 24, hasLIM: true)
								}
							}
						}
						.searchable(text: .constant(""))
						.presentationDetents([.fraction(0.06), .medium, .large])
						.presentationBackgroundInteraction(.enabled)
						.interactiveDismissDisabled(true)
					}
				
			} else {
				
				VStack(spacing: 32) {
					Image(systemName: "move.3d")
						.resizable()
						.scaledToFit()
						.frame(width: 60)
						.foregroundColor(.secondary)
					Text("Muoviti attorno per permettere all'app di geolocalizzarti")
						.multilineTextAlignment(.center)
						.font(.headline)
					
					if locationManager.canReachServer {
						HStack {
							Image(systemName: "wifi.exclamationmark")
							Text("Server non disponibile")
								
//								.padding(.vertical, 8)
//								.padding(.horizontal)
//								.background {
//									Capsule()
//										.foregroundColor(.red)
//								}
						}
						.font(.headline)
						.foregroundColor(.red)
					}
				}
				.task {
					locationManager.maps = await locationManager.fetchMaps()
				}
				.onAppear {
					locationManager.selectedMap = locationManager.maps.first
					locationManager.startScanning()
				}
				.onDisappear { locationManager.stopScanning() }
				
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
