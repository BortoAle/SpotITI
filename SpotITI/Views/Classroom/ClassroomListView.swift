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
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						ForEach(0..<10) { _ in
							UtilityCard(name: "👑Presidenza")
						}
					}
				}
				
				Text("Aule")
					.font(.headline)
				Text("A")
					.font(.subheadline)
					.foregroundColor(.secondary)
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
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
