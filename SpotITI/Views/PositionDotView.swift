//
//  PositionDotView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 13/05/23.
//

import SwiftUI

struct PositionDotView: View {
    var body: some View {
		ZStack {
			Circle()
				.frame(width: 35, height: 35)
				.foregroundStyle(.white)
				.shadow(color: .black.opacity(0.1), radius: 10)
			Circle()
				.frame(width: 25, height: 25)
				.foregroundStyle(.blue)
		}
    }
}

#Preview {
	PositionDotView()
		.previewLayout(.sizeThatFits)
}
