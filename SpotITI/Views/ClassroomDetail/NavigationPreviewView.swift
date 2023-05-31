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
		.task {
			do {
				guard
					let currentNodeId = scanManager.ean8Code,
					let route = try await apiManager.getRoutes(startNodeId: currentNodeId, endSpot: spot).first
				else {
					canNavigate = false
					return
				}
				self.route = route
				canNavigate = true
			} catch {
				print(error.localizedDescription)
			}
		}
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
				navigationInfo
				navigationButton
			}
			.padding(.leading, 24)
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
			Text("2") +
			Text("min")
				.foregroundColor(.secondary)
			Text("•")
			Text("250") +
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
