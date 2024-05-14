//
//  Feature.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 31/05/23.
//

import SwiftUI

struct Feature: View {
	
	let imageName: String
	let title: String
	let description: String
	
	var body: some View {
		HStack(spacing: 17) {
			Image(systemName: imageName)
				.font(.largeTitle)
				.fontWeight(.heavy)
				.scaledToFit()
				.padding(8)
				.foregroundStyle(.primary)
			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.title3)
					.bold()
				Text(description)
					.font(.subheadline)
					.lineSpacing(-10)
			}
		}
	}
}


struct Feature_Previews: PreviewProvider {
    static var previews: some View {
		Feature(imageName: "compass", title: "Bussola", description: "Orientati facilmente")
    }
}
