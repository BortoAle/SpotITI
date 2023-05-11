//
//  ClassroomCard.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 01/05/23.
//

import SwiftUI

struct ClassroomCard: View {
	
	let name: String
	let seats: Int
	let hasLIM: Bool
	
    var body: some View {
		HStack(alignment: .bottom, spacing: 32) {
			Text(name)
				.font(.largeTitle)
				.fontWeight(.semibold)
			VStack {
				Image(systemName: "chair")
					.foregroundColor(.secondary)
				Text("24 seats")
			}
			VStack {
				Image(systemName: "laptopcomputer")
					.foregroundColor(.secondary)
				Text("Has LIM")
			}
		}
		.padding()
    }
}

struct ClassroomCard_Previews: PreviewProvider {
    static var previews: some View {
		ClassroomCard(name: "AB", seats: 24, hasLIM: true)
			.previewLayout(.fixed(width: 300, height: 80))
    }
}
