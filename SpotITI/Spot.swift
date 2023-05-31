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
	
}
