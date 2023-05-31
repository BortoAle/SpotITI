//
//  SpotData.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 27/05/23.
//

import Foundation

struct SpotData: Codable {
	
	let seats: String?
	let has_iwb: Bool
	let has_projector: Bool
	let is_lab: Bool
	let pc: String?
	
	static let mockup = SpotData(
		seats: "14",
		has_iwb: true,
		has_projector: false,
		is_lab: false,
		pc: "2"
	)
	
}
