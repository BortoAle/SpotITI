//
//  Edge.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 14/05/23.
//

import Foundation

struct Edge: Codable {
	let id: String
	let startVertexId: String
	let endVertexId: String
	let weight: Int
}
