//
//  NavigationPreviewView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI

struct NavigationPreviewView: View {
	
	@EnvironmentObject var locationManager: LocationManager
	var namespace: Namespace.ID
	
    var body: some View {
		VStack(spacing: 32) {
			
			HStack {
				Text("Navigazione verso AB")
					.font(.headline)
				Spacer()
				Button {
					locationManager.currentView = .home
					locationManager.selectedDetent = .fraction(0.99)
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
				}
			
			HStack(spacing: 32) {
				Text("12:24 • 13min")
					.font(.headline)
					.foregroundColor(.secondary)
				
				Button {
					withAnimation(.easeInOut) {
						locationManager.currentView = .navigation
					}
					locationManager.selectedDetent = .fraction(0.35)

				} label: {
					HStack {
						Image(systemName: "paperplane.fill")
						Text("Naviga")
					}
					.font(.title2)
					.fontWeight(.semibold)
					.padding(8)
					.padding(.horizontal, 8)
				}
				.controlSize(.mini)
				.buttonStyle(.borderedProminent)

			}
			.frame(maxWidth: .infinity, alignment: .bottomTrailing)
			
		}
		.padding()
    }
}

struct NavigationPreviewView_Previews: PreviewProvider {
	
	@Namespace static var namespace
	
    static var previews: some View {
		NavigationPreviewView(namespace: namespace)
			.previewLayout(.sizeThatFits)
			.environmentObject(LocationManager())
    }
}
