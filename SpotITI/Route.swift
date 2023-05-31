//
//  Route.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 14/05/23.
//

import Foundation

struct Route: Codable {
	
	let nodes: [Node]
	let lenght: Int
	
	static let mockup =  Route(
		nodes: [],
		lenght: 0
	)
	
}
