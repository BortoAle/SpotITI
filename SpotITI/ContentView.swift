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
	
	@EnvironmentObject var locationManager: LocationManager
	@Namespace var namespace
	@State var showDebugAlert: Bool = false
	@State var showCurrentPosition: Bool = true
	
	var body: some View {
		ZStack {
			CameraPreviewView(session: locationManager.session)
//				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.ignoresSafeArea()
			
//			Rectangle()
//				.fill(.ultraThinMaterial)
//				.frame(height: 40)
//				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//				.ignoresSafeArea()
			
			CompassView()
				.offset(y: -120)
				.opacity(0.9)
		}
		.sheet(isPresented: .constant(true)) {
			ZStack {
				NavigationStack {
							
							if showDebugAlert {
								Text(locationManager.qrCodeValue)
							}
			
							VStack {
								switch locationManager.currentView {
									case .home:
										ClassroomListView(namespace: namespace)
											.searchable(text: .constant(""))
									case .detail:
										NavigationPreviewView(namespace: namespace)
									case .navigation:
										NavigationView()
								}
							}
							.toolbar(locationManager.currentView == .home ? .visible : .hidden, for: .navigationBar)
							.navigationTitle("Aule")
							.toolbar(content: {
								ToolbarItem(placement: .navigationBarTrailing) {
									Button {
										showDebugAlert = true
									} label: {
										Image(systemName: "info.circle")
									}

								}
							})
							.navigationBarTitleDisplayMode(.inline)
						}
						.presentationDetents(locationManager.presentationDetents, selection: $locationManager.selectedDetent)
						.presentationBackgroundInteraction(.enabled)
						.interactiveDismissDisabled(true)
	//					.padding(.vertical)
						.presentationCornerRadius(30)
					.presentationDragIndicator(.hidden)
				
//				PositionDotView()
//					.ignoresSafeArea()
//					.padding(.horizontal, 32)
//					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
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

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(LocationManager())
	}
}
