//
//  UtilityCard.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 13/05/23.
//

import SwiftUI

struct UtilityCard: View {
	
	let name: String
	
	var body: some View {
		Text(name)
			.font(.headline)
			.padding()
			.background {
				RoundedRectangle(cornerRadius: 6)
					.foregroundColor(Color(uiColor: .secondarySystemBackground))
			}
	}
}

struct UtilityCard_Previews: PreviewProvider {
    static var previews: some View {
		UtilityCard(name: "👑Presidenza")
    }
}
