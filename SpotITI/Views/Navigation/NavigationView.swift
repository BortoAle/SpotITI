//
//  NavigationView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI

struct NavigationView: View {
	
	@EnvironmentObject var locationManager: LocationManager
	
	var body: some View {
		VStack(spacing: 32) {
			HStack {
				Image(systemName: "stairs")
					.fontWeight(.bold)
				Text("Scendi le scale")
			}
			.font(.title)
			.frame(maxWidth: .infinity, alignment: .center)
			
			
			HStack(spacing: 24) {
				
				VStack {
					Text("10%")
						.font(.subheadline)
						.fontWeight(.semibold)
					Text("completato")
						.font(.caption2)
						.foregroundColor(.secondary)
				}
				.font(.headline)
				
				HStack(alignment: .center, spacing: 32) {
					
					Button {
						withAnimation(.easeInOut) {
							locationManager.currentView = .home
						}
						locationManager.selectedDetent = .fraction(0.99)
						
					} label: {
						HStack {
							Image(systemName: "xmark")
							Text("Termina")
						}
						.font(.headline)
						.foregroundColor(.white)
						.padding(.horizontal, 24)
						.padding(.vertical)
					}
					.buttonStyle(.borderedProminent)
					.controlSize(.mini)
					.tint(.red)
					
				}
				
			}
			.padding(.leading, 32)
			.background {
				Capsule()
					.foregroundColor(Color(uiColor: .secondarySystemBackground))
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
		}
		.padding()
	}
}

struct NavigationView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView()
			.environmentObject(LocationManager())
			.previewLayout(.sizeThatFits)
	}
}
