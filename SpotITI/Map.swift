//
//  Map.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import Foundation

struct Map: Codable {
	
	static let map1 = Map(id: "00001", name: "Casa Mamma", edges: [], vertices: [
		Vertex(id: 90311017, x: 0, y: 0, floor: 0),
	Vertex(id: 00000024, x: 100, y: 0, floor: 0),
	Vertex(id: 00000031, x: 100, y: 150, floor: 0)
	], calculatedRoutes: [])
	
	let id: String
	let name: String
	let edges: [Edge]
	let vertices: [Vertex]
	let calculatedRoutes: [Route]
}
