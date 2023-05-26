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
	
	@State var canNavigate: Bool = true
	
	var body: some View {
		VStack(spacing: 32) {
			navigationHeader
			infoGrid
			navigationFooter
		}
		.padding()
	}

	// Header of the navigation
	var navigationHeader: some View {
		HStack {
			Text("Navigazione verso AB")
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

	// Information grid
	var infoGrid: some View {
		Grid {
			gridRowForHeaders
			Divider()
			gridRowForDetails
		}
	}

	// Grid row for headers
	var gridRowForHeaders: some View {
		GridRow {
			infoItem(image: "house.lodge", text: "Tipo")
			infoItem(image: "chair", text: "Posti")
			infoItem(image: "pc", text: "N° PC")
			infoItem(image: "tv", text: "Lim")
			infoItem(image: "videoprojector", text: "Proiettore")
		}
		.font(.subheadline)
		.foregroundColor(.secondary)
	}
	
	// Grid row for details
	var gridRowForDetails: some View {
		GridRow {
			Text("LAB")
			Text("18")
			Text("14")
			Image(systemName: "checkmark")
				.foregroundColor(.green)
			Image(systemName: "xmark")
				.foregroundColor(.red)
		}
	}
	
	// Footer for navigation
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
			Task {
				guard let currentVertexId = scanManager.ean8Code, let route = try await apiManager.getRoutes(mapId: 1, startVertexId: currentVertexId, endVertexId: 54027541).first else {
					canNavigate = false
					return
				}
				canNavigate = true
				try await navigationManager.startNavigation(route: route)
			}
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
	
	// Info item for the grid
	func infoItem(image: String, text: String) -> some View {
		VStack {
			Image(systemName: image)
			Text(text)
		}
	}
}

// MARK: - PreviewProvider

struct NavigationPreviewView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationPreviewView()
			.previewLayout(.sizeThatFits)
			.environmentObject(NavigationManager())
	}
}
