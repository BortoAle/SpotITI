//
//  ContentView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI

enum ViewType {
	case home, detail, navigation
}

struct ContentView: View {
	
	@State var showNavigationView: Bool = true
	@EnvironmentObject var locationManager: LocationManager
	
	
	var body: some View {
		ZStack {
			CameraPreviewView(session: locationManager.session)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.ignoresSafeArea()
			
			VStack {
				CompassView()
					.frame(maxHeight: .infinity, alignment: .center)
				
				VStack {
					Capsule()
						.frame(width: 40, height: 6)
						.foregroundColor(.gray.opacity(0.5))
						.padding()
						VStack {
							switch locationManager.currentView {
								case .home:
									ClassroomListView()
										.searchable(text: .constant(""))
								case .detail:
									NavigationPreviewView()
								case .navigation:
									NavigationView()
							}
						}
				}
				.background {
					RoundedRectangle(cornerRadius: 25)
						.foregroundColor(.gray.opacity(0.1))
						.ignoresSafeArea()
				}
			}
			
		}
		//		.sheet(isPresented: $showNavigationView) {
		//			NavigationStack {
		//
		//				VStack {
		//					switch locationManager.currentView {
		//						case .home:
		//							ClassroomListView()
		//								.searchable(text: .constant(""))
		//						case .detail:
		//								NavigationPreviewView()
		//						case .navigation:
		//							NavigationView()
		//					}
		//				}
		//				.toolbar(locationManager.currentView == .home ? .visible : .hidden, for: .navigationBar)
		//				.navigationTitle("Aule")
		//
		//			}
		//			.presentationDetents([locationManager.currentView == .home ? .fraction(0.99) : locationManager.currentView == .detail ? .fraction(0.4) : .fraction(0.35)])
		//			.presentationBackgroundInteraction(.enabled)
		//			.interactiveDismissDisabled(true)
		//		}
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

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(LocationManager())
	}
}
