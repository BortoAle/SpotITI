//
//  InfoGrid.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 31/05/23.
//

import SwiftUI

struct InfoGrid: View {
	
	let spot: Spot
	
    var body: some View {
		Grid {
			gridRowForHeaders
			Divider()
			gridRowForDetails
		}
    }

	// Grid row for headers
	var gridRowForHeaders: some View {
		GridRow {
			infoItem(image: "house.lodge", text: "Tipo")
			infoItem(image: "chair", text: "Posti")
			infoItem(image: "pc", text: "N° PC")
			infoItem(image: "tv", text: "Lim")
			infoItem(image: "videoprojector", text: "Proiettore")
		}
		.font(.subheadline)
		.foregroundColor(.secondary)
	}
	
	// Grid row for details
	var gridRowForDetails: some View {
		GridRow {
			Text(spot.data.is_lab ? "Lab" : "Aula")
			Text(spot.data.seats ?? "N/A")
			Text(spot.data.pc ?? "N/A")
			Image(systemName: spot.data.has_iwb ? "checkmark" : "xmark")
				.foregroundColor(spot.data.has_iwb ? .green : .red)
			Image(systemName: spot.data.has_projector ? "checkmark" : "xmark")
				.foregroundColor(spot.data.has_projector ? .green : .red)
		}
	}
	
	// Info item for the grid
	func infoItem(image: String, text: String) -> some View {
		VStack {
			Image(systemName: image)
			Text(text)
		}
	}
}

struct InfoGrid_Previews: PreviewProvider {
    static var previews: some View {
		InfoGrid(spot: Spot.mockup)
			.previewLayout(.sizeThatFits)
    }
}
