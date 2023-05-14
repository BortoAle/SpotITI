//
//  ClassroomListView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI

// MARK: - ClassroomGridView

struct ClassroomGridView: View {
	
	@EnvironmentObject private var locationManager: NavigationManager

	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				utilitySection
				classroomsSection
			}
			.padding()
		}
	}
}

// MARK: - Subviews

extension ClassroomGridView {
	// Section for utilities
	var utilitySection: some View {
		VStack(alignment: .leading) {
			Text("Utilità")
				.font(.headline)
			LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))]) {
				UtilityCard(name: "Servizi Donne", emoji: "🚾")
				UtilityCard(name: "Servizi Uomini", emoji: "🚾")
				UtilityCard(name: "Presidenza", emoji: "👑")
				UtilityCard(name: "Aula Magna", emoji: "🪑")
			}
		}
	}

	// Section for classrooms
	var classroomsSection: some View {
		VStack(alignment: .leading) {
			Text("Aule")
				.font(.headline)
			Text("A")
				.font(.subheadline)
				.foregroundColor(.secondary)
			LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
				ForEach(0..<11) { _ in
					ClassroomCard(name: "AB")
						.onTapGesture {
							withAnimation(.easeInOut) {
								locationManager.currentView = .detail
							}
							locationManager.selectedDetent = .fraction(0.35)
						}
				}
			}
		}
	}
}

// MARK: - PreviewProvider

struct ClassroomGridView_Previews: PreviewProvider {
	static var previews: some View {
		ClassroomGridView()
			.environmentObject(NavigationManager())
	}
}
