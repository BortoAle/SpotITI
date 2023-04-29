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

struct Edge: Codable {
	let id: String
	let startVertexId: String
	let endVertexId: String
	let weight: Int
}

struct Vertex: Codable {
	let id: String
	let x: Int
	let y: Int
	let floor: Int
}

struct Route: Codable {
	
}
