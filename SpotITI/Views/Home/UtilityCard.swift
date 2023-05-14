//
//  UtilityCard.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 13/05/23.
//

import SwiftUI

struct UtilityCard: View {
	
	let name: String
	let emoji: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(emoji)
			Text(name)
				.font(.headline)
				.fontWeight(.medium)
		}
		.padding()
		.frame(maxWidth: .infinity, alignment: .leading)
		.background {
			RoundedRectangle(cornerRadius: 6)
				.foregroundColor(Color(uiColor: .secondarySystemBackground))
		}
	}
}

struct UtilityCard_Previews: PreviewProvider {
    static var previews: some View {
		UtilityCard(name: "Presidenza", emoji: "👑")
    }
}
