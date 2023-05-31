//
//  NavigationView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI

struct NavigationView: View {
	
	@EnvironmentObject var navigationManager: NavigationManager
	@EnvironmentObject var scanManager: ScanManager
	@EnvironmentObject var apiManager: APIManager

	private let buttonColor: Color = .red
	private let capsuleColor: Color = Color(uiColor: .secondarySystemBackground)
	private let paddingSize: CGFloat = 8

	var body: some View {
		VStack(spacing: 32) {
			directionView
			progressView
		}
		.padding()
		.onChange(of: scanManager.ean8Code ?? 0) { newValue in
		#warning("se non funziona controllare default value 0")
			navigationManager.updatePosition(barcodeValue: newValue)
		}
	}

	var directionView: some View {
		
		HStack {
			Image(systemName: "stairs")
				.fontWeight(.bold)
			Text("Scendi le scale")
		}
		.font(.title)
		.frame(maxWidth: .infinity, alignment: .center)
	}

	var progressView: some View {
		HStack {
			PositionDotView()
			progressDetailsView
		}
	}

	var progressDetailsView: some View {
		HStack(spacing: 24) {
			progressStatsView
			controlsView
		}
		.padding(.leading, 32)
		.background {
			Capsule()
				.foregroundColor(capsuleColor)
		}
		.frame(maxWidth: .infinity, alignment: .trailing)
	}

	var progressStatsView: some View {
		VStack {
			Text("10%")
				.font(.subheadline)
				.fontWeight(.semibold)
			Text("completato")
				.font(.caption2)
				.foregroundColor(.secondary)
		}
		.font(.headline)
	}

	var controlsView: some View {
		HStack(alignment: .center, spacing: 32) {
			terminateButton
		}
	}

	var terminateButton: some View {
		Button {
			navigationManager.setCurrentView(view: .home)
			navigationManager.stopNavigation()
		} label: {
			HStack {
				Image(systemName: "xmark")
				Text("Termina")
			}
			.font(.headline)
			.foregroundColor(.white)
			.padding(paddingSize)
		}
		.buttonStyle(.borderedProminent)
		.controlSize(.mini)
		.tint(buttonColor)
	}
}

struct NavigationView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView()
			.previewLayout(.sizeThatFits)
			.environmentObject(NavigationManager())
			.environmentObject(ScanManager())
			.environmentObject(APIManager())
	}
}
