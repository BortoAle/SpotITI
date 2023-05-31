//
//  Category.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 26/05/23.
//

import Foundation

struct Category: Codable {
	
	let id: Int
	let name: String
	
	var type: CategoryType {
		// Returns the Spot category based on the id
		CategoryType.allCases.first(where: { $0.rawValue == id }) ?? .undefined
	}
	
	enum CategoryType: Int, Codable, CaseIterable {
		case classroom = 1
		case bathroom = 2
		case machines = 3
		case undefined
		
		var name: String {
			switch self {
				case .classroom:
					return "Classe"
				case .bathroom:
					return "Bagno"
				case .machines:
					return "Distributori"
				case .undefined:
					return ""
			}
		}
		
		var icon: String {
			switch self {
				case .classroom:
					return "🪑"
				case .bathroom:
					return "🚻"
				case .machines:
					return "🍪"
				case .undefined:
					return ""
			}
		}
		
		// true for everything except classrooms
		var isUtility: Bool {
			switch self {
				case .classroom:
					return false
				default:
					return true
			}
		}
	}
	
}
