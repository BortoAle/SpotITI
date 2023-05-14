//
//  ClassroomListView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI

struct ClassroomListView: View {
	
	@EnvironmentObject var locationManager: LocationManager
	var namespace: Namespace.ID
	
	var body: some View {
		
		ScrollView {
			VStack(alignment: .leading) {
				Text("Utilità")
					.font(.headline)
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))]) {
					UtilityCard(name: "Servizi Donne", emoji: "🚾")
					UtilityCard(name: "Servizi Uomini", emoji: "🚾")
					UtilityCard(name: "Presidenza", emoji: "👑")
					UtilityCard(name: "Aula Magna", emoji: "🪑")
				}
				
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
			.padding()
		}
	}
}

struct ClassroomListView_Previews: PreviewProvider {
	@Namespace static var namespace
	
	static var previews: some View {
		ClassroomListView(namespace: namespace)
			.environmentObject(LocationManager())
	}
}
