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
			
			Grid {
				GridRow {
					VStack {
						Image(systemName: "door.sliding.right.hand.open")
						Text("Aula")
					}
					//					.matchedGeometryEffect(id: "row", in: namespace)
					VStack {
						Image(systemName: "stairs")
						Text("Piano")
					}
					VStack {
						Image(systemName: "house")
						Text("Blocco")
					}
					VStack {
						Image(systemName: "chair")
						Text("Posti")
					}
					VStack {
						Image(systemName: "pc")
						Text("Lim")
					}
				}
				.font(.subheadline)
				.foregroundColor(.secondary)
				
				ForEach(0..<10) { _ in
					Divider()
						GridRow {
							Text("AB")
								.font(.headline)
							Text("2")
							Text("H")
							Text("18")
							Image(systemName: "checkmark.seal")
								.foregroundColor(.green)
						}
					.onTapGesture {
						withAnimation(.easeInOut) {
							locationManager.currentView = .detail
						}
						locationManager.selectedDetent = .fraction(0.45)
						
//							DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//								locationManager.presentationDetents = [.fraction(0.45)]
//							}
					}
				}
				.padding(.vertical, 8)
			}
			.padding(.horizontal)
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
