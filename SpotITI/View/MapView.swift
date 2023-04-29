//
//  MapView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI

struct MapView: View {
	
	@State var maps: [Map] = []
	let manager = APIManager()
	
	var body: some View {
		ZStack {
			Image("piantina")
				.resizable()
				.scaledToFit()
			
			ForEach(maps, id: \.id) { map in
				ForEach(map.vertices, id: \.id) { vertex in
					Circle()
						.fill(Color.red)
						.frame(width: 10, height: 10)
						.position(x: CGFloat(vertex.x), y: CGFloat(vertex.y))
				}
			}
			
		}
		.task {
			do {
				maps = try await manager.fetchMaps()
				print(maps)
			} catch {
				print(error)
			}
		}
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
	}
}
