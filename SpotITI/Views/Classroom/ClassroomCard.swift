//
//  ClassroomCard.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 13/05/23.
//

import SwiftUI

struct ClassroomCard: View {
	
	let name: String
	
    var body: some View {
        Text(name)
			.font(.title)
			.padding(.horizontal, 24)
			.padding(.vertical, 8)
			.frame(maxWidth: .infinity)
			.background {
				RoundedRectangle(cornerRadius: 6)
					.foregroundColor(Color(uiColor: .secondarySystemBackground))
			}
    }
}

struct ClassroomCard_Previews: PreviewProvider {
    static var previews: some View {
		ClassroomCard(name: "AB")
    }
}
