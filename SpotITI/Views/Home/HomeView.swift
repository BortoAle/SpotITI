//
//  HomeView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
	
	@Environment(NavigationManager.self) private var navigationManager: NavigationManager
	@Environment(APIManager.self) private var apiManager: APIManager
	@Environment(ScanManager.self) private var scanManager: ScanManager
	@Environment(AppScreen.self) private var appScreen: AppScreen

	@Binding var selectedSpot: Spot?
	@State private var searchText: String = ""
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading) {
					utilitySection
					classroomsSection
				}
				.padding()
			}
			.navigationTitle("SpotITI")
			.navigationBarTitleDisplayMode(.inline)
			.searchable(text: $searchText, prompt: "Cerca un aula")
		}
	}
	
	// Section for utilities
	var utilitySection: some View {
		Section {
			LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
				ForEach(categoriesSearchResults(categories: apiManager.categories), id: \.id) { category in
					Button {
						Task {
							if let currentNodeId = scanManager.ean8Code {
								do {
									if let route = try await apiManager.getRoutes(startNodeId: currentNodeId, endCategory: category.type).first {
										navigationManager.startNavigation(route: route)
                                        appScreen.setCurrentView(view: .navigation)
									}
								} catch {
									print(error.localizedDescription)
								}
							}
						}
					} label: {
						UtilityCard(name: category.type.name, icon: category.type.icon)
					}
					
				}
			}
		} header: {
			Text("Utilità")
				.font(.headline)
		}
	}
	
	var classroomsSection: some View {
		// Classrooms section
		Section {
			ForEach(blockSearchResults(blocks: Array(apiManager.classrooms.keys.sorted(by: { $0 < $1 }))), id: \.hashValue) { block in
				// Block section
				Section {
					if let blockClassroom = apiManager.classrooms[block] {
						LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 8)], spacing: 8) {
							ForEach(classroomsSearchResults(classrooms: blockClassroom), id: \.name) { classroom in
								Button {
									selectedSpot = classroom
									appScreen.setCurrentView(view: .navigationPreview)
									generator.impactOccurred()
								} label: {
									ClassroomCard(name: classroom.name)
								}
							}
						}
					}
				} header: {
					Text(String(block))
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}
			}
		} header: {
			Text("Aule")
				.font(.headline)
		}
	}
	
	func categoriesSearchResults(categories: [Category]) -> [Category] {
		if searchText.isEmpty {
			return categories
		} else {
			return categories.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
		}
	}
	
	func blockSearchResults(blocks: [Character]) -> [Character] {
		if searchText.isEmpty {
			return blocks
		} else {
			return blocks.filter({ $0.lowercased().contains(searchText.lowercased()) })
		}
	}
	
	
	func classroomsSearchResults(classrooms: [Spot]) -> [Spot] {
		if searchText.isEmpty {
			return classrooms
		} else {
			return classrooms.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
		}
	}
	
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(selectedSpot: .constant(Spot.mockup))
			.environment(NavigationManager())
			.environment(ScanManager())
			.environment(APIManager())
            .environment(AppScreen())
	}
}
