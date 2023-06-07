//
//  NavigationPreviewView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI

struct NavigationPreviewView: View {
	
	@EnvironmentObject private var navigationManager: NavigationManager
	@EnvironmentObject private var apiManager: APIManager
	@EnvironmentObject private var scanManager: ScanManager
	
	@State var canNavigate: Bool = false
	@State var route: Route?
	
	let spot: Spot
	
	var body: some View {
		VStack(spacing: 32) {
			navigationHeader
			InfoGrid(spot: spot)
			navigationFooter
		}
		.padding()
		.animation(.easeInOut, value: canNavigate)
		.task { await fetchRoute() }
	}

	// View header
	var navigationHeader: some View {
		HStack {
			Text("Navigazione verso \(spot.name)")
				.font(.title3)
				.fontWeight(.semibold)
			Spacer()
			Button {
				navigationManager.setCurrentView(view: .home)
			} label: {
				Image(systemName: "xmark")
					.padding(8)
					.background {
						Circle()
							.foregroundColor(.gray.opacity(0.2))
					}
			}
			.tint(.gray)
		}
	}
	
	// View footer
	var navigationFooter: some View {
		HStack {
			PositionDotView()
			HStack(spacing: 16) {
				if canNavigate {
					navigationInfo
						.padding(.trailing, 24)
						.transition(.move(edge: .trailing))
				}
				navigationButton
			}
			.background {
				Capsule()
					.foregroundColor(Color(uiColor: .secondarySystemBackground))
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
		}
		
	}
	
	// Navigation info
	var navigationInfo: some View {
		HStack(spacing: 4) {
			Text(route?.lenght ?? 0, format: .number) +
			Text("min")
				.foregroundColor(.secondary)
			Text("•")
			Text(route?.lenght ?? 0, format: .number) +
			Text("m")
				.foregroundColor(.secondary)
		}
		.font(.headline)
	}
	
	// Navigation button
	var navigationButton: some View {
		Button {
				navigationManager.startNavigation(route: route!)
		} label: {
			HStack {
				Image(systemName: "paperplane.fill")
				Text("Naviga")
			}
			.font(.headline)
			.foregroundColor(.white)
			.padding(8)
		}
		.buttonStyle(.borderedProminent)
		.controlSize(.mini)
		.disabled(!canNavigate)
	}
	
	func fetchRoute() async {
		do {
			guard let currentNodeId = scanManager.ean8Code else {
				await MainActor.run { canNavigate = false }
				return
			}
			let result = try await apiManager.getRoutes(startNodeId: currentNodeId, endSpot: spot)
			await MainActor.run {
				self.route = result
				canNavigate = true
			}
		} catch {
			print(error.localizedDescription)
		}
	}
	
}

struct NavigationPreviewView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationPreviewView(spot: Spot.mockup)
			.previewLayout(.sizeThatFits)
			.environmentObject(NavigationManager())
			.environmentObject(ScanManager())
			.environmentObject(APIManager())
	}
}
