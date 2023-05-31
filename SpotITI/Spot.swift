//
//  Spot.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 26/05/23.
//

import Foundation

struct Spot: Codable {
	
	let id: Int
	let name: String
	let category: Category
	let data: SpotData
	let nodes: [Node]
	
	static let mockup = Spot(
		id: 12345678,
		name: "AB",
		category: Category.mockup,
		data: SpotData.mockup,
		nodes: []
	)
	
}
