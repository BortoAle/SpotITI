//
//  HomeView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
	
	@EnvironmentObject private var navigationManager: NavigationManager
	@EnvironmentObject private var apiManager: APIManager
	@EnvironmentObject private var scanManager: ScanManager
	
	@State private var searchText: String = ""
	@State private var debugActive: Bool = false
	
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
	
	// Toolbar content for the debug mode
	var debugToolbarContent: some View {
		Button {
			debugActive.toggle()
		} label: {
			Image(systemName: "ladybug")
		}
	}
	
	// Section for utilities
	var utilitySection: some View {
			Section {
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
					ForEach(apiManager.categories, id: \.id) { category in
						Button {
							Task {
								if let currentNodeId = scanManager.ean8Code {
									do {
										if let route = try await apiManager.getRoutes(startNodeId: currentNodeId, endCategory: category.type).first {
											navigationManager.startNavigation(route: route)
										}
									} catch {
										print(error.localizedDescription)
									}
								}
							}
							print("Tapped")
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
			ForEach(Array(apiManager.classrooms.keys.sorted(by: { $0 < $1 })), id: \.hashValue) { block in
				// Block section
				Section {
					if let blockClassroom = apiManager.classrooms[block] {
						LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 8)], spacing: 8) {
							ForEach(blockClassroom, id: \.name) { classroom in
								Button {
									navigationManager.selectedSpot = classroom
									navigationManager.setCurrentView(view: .navigationPreview)
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
						.foregroundColor(.secondary)
				}
			}
		} header: {
			Text("Aule")
				.font(.headline)
		}
	}
	
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
			.environmentObject(NavigationManager())
			.environmentObject(ScanManager())
	}
}
