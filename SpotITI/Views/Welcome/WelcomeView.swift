//
//  WelcomeView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 31/05/23.
//

import SwiftUI

struct WelcomeView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@AppStorage("showWelcomeScreen") var showWelcomeScreen: Bool = true
	
	var body: some View {
			VStack(alignment: .center) {
				Spacer()
				title
				Spacer()
				features
				Spacer()
				nextButton
			}
			.padding(32)
	}
	
	var title: some View {
		VStack {
			Text("SpotITI")
				.font(.largeTitle)
				.fontWeight(.semibold)
			Text("Trova la via più breve")
				.font(.title3)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
		}
	}
	
	var features: some View {
		VStack(alignment: .leading, spacing: 32) {
			Feature(imageName: "arrow.up", title: "Naviga", description: "Scegli l'aula di destinazione e sei subito pronto a navigare.")
			Feature(imageName: "figure.walk", title: "Risparmia", description: "Risparmia kcal e minuti preziosi. L'app troverà sempre la strada più corta.")
			Feature(imageName: "info", title: "Scopri", description: "Trova tutte le informazioni importanti sulle aule.")
		}
	}
	
	var nextButton: some View {
		Button {
				showWelcomeScreen = false
		} label: {
			Text("Capito")
				.font(.headline)
				.frame(maxWidth: .infinity)
				.padding(.vertical, 8)
		}
		.buttonStyle(.borderedProminent)
	}
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
