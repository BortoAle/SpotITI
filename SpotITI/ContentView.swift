//
//  ContentView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI
import AVFoundation

enum ViewType {
	case home, detail, navigation
}

struct ContentView: View {
	
	@EnvironmentObject var locationManager: LocationManager
	@EnvironmentObject var scanner: ScanditEAN8Scanner
	@Namespace var namespace
	@State var showDebugAlert: Bool = false
	@State var showCurrentPosition: Bool = true
	
	var body: some View {
		ZStack {
			ScannerView(scanner: scanner)
				.ignoresSafeArea()
			
//			CameraPreviewView(session: locationManager.session)
//				.frame(maxWidth: .infinity, maxHeight: .infinity)
//				.ignoresSafeArea()
			
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
								Text(scanner.ean8Code ?? "NON LETTO")
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
										showDebugAlert.toggle()
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
					.onChange(of: scanner.ean8Code, perform: { value in
						if showDebugAlert {
							if let soundURL = Bundle.main.url(forResource: "beep", withExtension: "m4a") {
								var soundID: SystemSoundID = 0
								AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
								AudioServicesPlaySystemSound(soundID)
							}
							
					let generator = UIImpactFeedbackGenerator(style: .heavy)
							generator.impactOccurred()
						}
							})
				
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
//			locationManager.startScanning()
		}
//		.onDisappear { locationManager.stopScanning() }
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(LocationManager())
	}
}
