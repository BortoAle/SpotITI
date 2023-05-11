//
//  MapView.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import SwiftUI

struct MapView: View {
	
	@EnvironmentObject var locationManager: LocationManager
	@StateObject private var viewModel = CompassViewModel()
	
	@State private var zoomLevel: CGFloat = 1.0
	@State private var initialZoomLevel: CGFloat = 1.0
	@State private var currentOffset = CGSize.zero
	@State private var initialOffset = CGSize.zero
	
	var body: some View {
		GeometryReader { geometry in
			ScrollView([.horizontal, .vertical], showsIndicators: false) {
				VStack {
					Spacer(minLength: geometry.size.height / 2)
					HStack {
						Spacer(minLength: geometry.size.width / 2)
						ZStack {
							Image("piantina")
								.resizable()
								.scaledToFit()
							
							ForEach(locationManager.maps, id: \.id) { map in
								ForEach(map.vertices, id: \.id) { vertex in
									VStack {
										Circle()
											.frame(width: 4, height: 4)
											.foregroundColor(.green)
									}
									.position(x: CGFloat(vertex.x), y: CGFloat(vertex.y))
								}
							}
							
							ZStack {
								Path { path in
									let width = 40
									let height = 60
									
									path.move(to: CGPoint(x: width / 2, y: 0))
									path.addLine(to: CGPoint(x: 0, y: height))
									path.addLine(to: CGPoint(x: width, y: height))
									path.closeSubpath()
								}
								.fill(
									LinearGradient(
										gradient: Gradient(colors: [Color.blue.opacity(0), Color.blue.opacity(0.5)]),
										startPoint: .bottom,
										endPoint: .top
									)
								)
								.frame(width: 40, height: 60)
								.offset(y: 25)
								.rotationEffect(Angle.degrees(viewModel.heading))
								
								Circle()
									.fill(.white)
									.frame(width: 35, height: 35)
								Circle()
									.fill(.blue)
									.frame(width: 25, height: 25)
								
								
							}
							.position(x: CGFloat(locationManager.currentVertex?.x ?? 0), y: CGFloat(locationManager.currentVertex?.y ?? 0))
							.shadow(color: .black.opacity(0.1), radius: 6)
						}
						.scaleEffect(zoomLevel)
						.offset(currentOffset)
						.gesture(magnificationAndPanGesture())
						Spacer(minLength: geometry.size.width / 2)
					}
					Spacer(minLength: geometry.size.height / 2)
				}
			}
		}
	}
	
	func magnificationAndPanGesture() -> some Gesture {
		let magnificationGesture = MagnificationGesture()
			.onChanged { value in
				zoomLevel = initialZoomLevel * value
			}
			.onEnded { value in
				initialZoomLevel = zoomLevel
			}
		
		let panGesture = DragGesture()
			.onChanged { value in
				currentOffset = CGSize(width: initialOffset.width + value.translation.width, height: initialOffset.height + value.translation.height)
			}
			.onEnded { value in
				initialOffset = currentOffset
			}
		
		return magnificationGesture.simultaneously(with: panGesture)
	}
	
}


struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
	}
}
