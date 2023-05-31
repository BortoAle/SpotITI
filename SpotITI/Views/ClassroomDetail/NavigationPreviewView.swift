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
	
	var body: some View {
		VStack(spacing: 32) {
			navigationHeader
			infoGrid
			navigationFooter
		}
		.padding()
		.task {
			do {
				guard
					let currentNodeId = scanManager.ean8Code,
					let route = try await apiManager.getRoutes(startNodeId: currentNodeId, endSpot: navigationManager.selectedSpot!).first
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

	// Header of the navigation
	var navigationHeader: some View {
		HStack {
			Text("Navigazione verso \(navigationManager.selectedSpot!.name)")
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
			Text(navigationManager.selectedSpot!.data.is_lab ? "Lab" : "Aula")
			Text(navigationManager.selectedSpot!.data.seats ?? "N/A")
			Text(navigationManager.selectedSpot!.data.pc ?? "N/A")
			Image(systemName: navigationManager.selectedSpot!.data.has_iwb ? "checkmark" : "xmark")
				.foregroundColor(navigationManager.selectedSpot!.data.has_iwb ? .green : .red)
			Image(systemName: navigationManager.selectedSpot!.data.has_projector ? "checkmark" : "xmark")
				.foregroundColor(navigationManager.selectedSpot!.data.has_projector ? .green : .red)
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
//		NavigationPreviewView(spot: Spot(id: 1, name: "AB", category: Category(id: 0, name: "classrooms"), data: SpotData(seats: 23, has_iwb: false, has_projector: true, is_lab: false, pc: 1)))
		NavigationPreviewView()
			.previewLayout(.sizeThatFits)
			.environmentObject(NavigationManager())
	}
}
