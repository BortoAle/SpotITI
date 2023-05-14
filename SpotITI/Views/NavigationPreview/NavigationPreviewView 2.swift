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
					.font(.title3)
					.fontWeight(.semibold)
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
							Image(systemName: "house.lodge")
							Text("Tipo")
						}
						VStack {
							Image(systemName: "chair")
							Text("Posti")
						}
						VStack {
							Image(systemName: "pc")
							Text("N° PC")
						}
						VStack {
							Image(systemName: "tv")
							Text("Lim")
						}
						VStack {
							Image(systemName: "videoprojector")
							Text("Proiettore")
						}
					}
					.font(.subheadline)
					.foregroundColor(.secondary)
					
						Divider()
						GridRow {
							Text("LAB")
							Text("18")
							Text("14")
							Image(systemName: "checkmark")
								.foregroundColor(.green)
							Image(systemName: "xmark")
								.foregroundColor(.red)
					}
				}
			

			HStack {
				
				PositionDotView()
				
				HStack(spacing: 16) {
					
					HStack(spacing: 4) {
						Text("2") +
						Text("min")
							.foregroundColor(.secondary)
						Text("•")
						Text("250") +
						Text("m")
							.foregroundColor(.secondary)
					}
					.font(.headline)
					
					HStack(alignment: .center, spacing: 16) {
						
						Button {
							withAnimation(.easeInOut) {
								locationManager.currentView = .navigation
							}
							locationManager.selectedDetent = .fraction(0.2)

						} label: {
							HStack {
								Image(systemName: "paperplane.fill")
								Text("Naviga")
							}
							.font(.headline)
							.foregroundColor(.white)
							.padding(8)
						}
						.buttonStyle(.borderedProminent)
						.controlSize(.mini)

					}

				}
				.padding(.leading, 24)
				.background {
					Capsule()
						.foregroundColor(Color(uiColor: .secondarySystemBackground))
				}
			.frame(maxWidth: .infinity, alignment: .trailing)
			}
			
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
