//
//  NavigationPreviewView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI

struct NavigationPreviewView: View {
	
	@EnvironmentObject var locationManager: LocationManager
	
    var body: some View {
		VStack(spacing: 48) {
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
				.padding(.top, 8)
			}
			
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
				Text("12:24 • 13min")
					.font(.headline)
					.foregroundColor(.secondary)
				
				Button {
					locationManager.currentView = .navigation
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
    static var previews: some View {
        NavigationPreviewView()
			.previewLayout(.sizeThatFits)
			.environmentObject(LocationManager())
    }
}
