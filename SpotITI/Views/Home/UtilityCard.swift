//
//  UtilityCard.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 13/05/23.
//

import SwiftUI

struct UtilityCard: View {
	
	let name: String
	let icon: String
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Text(icon)
			Text(name)
				.font(.headline)
				.fontWeight(.medium)
		}
		.padding()
		.fixedSize(horizontal: false, vertical: true)
		.foregroundStyle(.primary)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
		.background {
			RoundedRectangle(cornerRadius: 8)
				.foregroundStyle(Color(uiColor: .secondarySystemBackground))
		}
	}
}

#Preview(traits: .fixedLayout(width: 150, height: 60)) {
	UtilityCard(name: "Presidenza", icon: "👑")
}
