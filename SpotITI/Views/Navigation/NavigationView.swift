//
//  NavigationView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 11/05/23.
//

import SwiftUI

struct NavigationView: View {
	
	@Environment(NavigationManager.self) var navigationManager: NavigationManager
	@Environment(ScanManager.self) var scanManager: ScanManager
	@Environment(APIManager.self) var apiManager: APIManager
	@Environment(AppScreen.self) private var appScreen: AppScreen

	private let buttonColor: Color = .red
	private let capsuleColor: Color = Color(uiColor: .secondarySystemBackground)
	private let paddingSize: CGFloat = 8

	var body: some View {
		VStack(spacing: 32) {
			directionView
			progressView
		}
		.padding()
		.onChange(of: scanManager.ean8Code ?? 0) { _, newValue in
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
//			PositionDotView()
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
				.foregroundStyle(capsuleColor)
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
				.foregroundStyle(.secondary)
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
			appScreen.setCurrentView(view: .home)
			navigationManager.stopNavigation()
		} label: {
			HStack {
				Image(systemName: "xmark")
				Text("Termina")
			}
			.font(.headline)
			.foregroundStyle(.white)
			.padding(paddingSize)
		}
		.buttonStyle(.borderedProminent)
		.controlSize(.mini)
		.tint(buttonColor)
	}
}

#Preview {
	NavigationView()
		.previewLayout(.sizeThatFits)
		.environment(NavigationManager())
		.environment(ScanManager())
		.environment(APIManager())
}
