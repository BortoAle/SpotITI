//
//  ClassroomListView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI

struct ClassroomListView: View {
	
	@EnvironmentObject var locationManager: LocationManager
	
	var body: some View {
		
		ScrollView {
			
			Grid {
				GridRow {
					VStack {
						Image(systemName: "door.sliding.right.hand.open")
						Text("Aula")
					}
					VStack {
						Image(systemName: "stairs")
						Text("Piano")
					}
					VStack {
						Image(systemName: "house")
						Text("Blocco")
					}
					VStack {
						Image(systemName: "square.fill")
						Text("Tipo")
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
						Text("LAB")
						Text("18")
						Image(systemName: "checkmark.seal")
							.foregroundColor(.green)
					}
					.onTapGesture {
						locationManager.currentView = .detail
					}
				}
				.padding(.vertical, 8)
			}
			.padding(.horizontal)
		}
	}
}

struct ClassroomListView_Previews: PreviewProvider {
	static var previews: some View {
		ClassroomListView()
			.environmentObject(LocationManager())
	}
}
