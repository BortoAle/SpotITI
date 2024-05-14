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
			.lineLimit(1)
			.foregroundStyle(.primary)
			.minimumScaleFactor(0.5)
			.padding(.horizontal, 24)
			.padding(.vertical, 8)
			.frame(maxWidth: .infinity)
			.fixedSize(horizontal: false, vertical: true)
			.frame(minHeight: 50, maxHeight: 100)
			.background {
				RoundedRectangle(cornerRadius: 8)
					.foregroundStyle(Color(uiColor: .secondarySystemBackground))
			}
    }
}

#Preview(traits: .fixedLayout(width: 85, height: 40)) {
	HomeView(selectedSpot: .constant(Spot.mockup))
		.environment(NavigationManager())
		.environment(ScanManager())
		.environment(APIManager())
		.environment(AppScreen())
}
