//
//  Map.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import Foundation

struct Map: Codable {
	let id: String
	let name: String
	let edges: [Edge]
	let vertices: [Vertex]
	let calculatedRoutes: [Route]
}
