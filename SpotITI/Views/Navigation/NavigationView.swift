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
		VStack(spacing: 48) {
			HStack {
				Image(systemName: "arrow.uturn.down")
					.fontWeight(.bold)
				Text("Cambia Direzione")
			}
			.font(.title)
			.frame(maxWidth: .infinity, alignment: .center)
			
			HStack {
				Grid {
					GridRow {
						Text("Piano")
						Text("Blocco")
					}
					.font(.caption)
					.foregroundColor(.secondary)
					GridRow {
						Text("1")
						Text("A")
					}
					.font(.title)
					.fontWeight(.bold)
				}
				
				ZStack {
					Circle()
						.frame(width: 35, height: 35)
						.foregroundColor(.white)
						.shadow(color: .blue.opacity(0.2), radius: 5)
					Circle()
						.frame(width: 25, height: 25)
						.foregroundColor(.blue)
				}
				Rectangle()
					.frame(height: 6)
					.foregroundColor(.gray.opacity(0.3))
				ZStack {
					Circle()
						.frame(width: 35, height: 35)
						.foregroundColor(.gray)
					Circle()
						.frame(width: 25, height: 25)
						.foregroundColor(.white)
				}
				
				Grid {
					GridRow {
						Text("Piano")
						Text("Blocco")
					}
					.font(.caption)
					.foregroundColor(.secondary)
					GridRow {
						Text("1")
						Text("A")
					}
					.font(.title)
					.fontWeight(.bold)
				}
			}
			
			HStack(spacing: 32) {
				Button {
					withAnimation(.easeInOut) {
						locationManager.currentView = .home
					}
					locationManager.selectedDetent = .fraction(0.99)
//					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//						locationManager.presentationDetents = [.fraction(0.99), .fraction(0.45)]
//					}
				} label: {
					HStack {
						Image(systemName: "xmark")
						Text("Termina")
					}
					.font(.title3)
					.fontWeight(.semibold)
					.padding(8)
					.padding(.horizontal, 8)
				}
				.tint(.red)
				.controlSize(.mini)
				.buttonStyle(.borderedProminent)

			}
			.frame(maxWidth: .infinity, alignment: .bottomTrailing)
			
		}
		.padding()
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
			.environmentObject(LocationManager())
    }
}
