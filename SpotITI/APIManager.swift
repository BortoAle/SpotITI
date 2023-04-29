//
//  APIMANAGER.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 29/04/23.
//

import Foundation

class APIManager: ObservableObject {
	
	func fetchMaps() async throws -> [Map] {
		let url = URL(string: "http://192.168.1.2:3000/maps")!
		let (data, _) = try await URLSession.shared.data(from: url)
		let decodedData = try JSONDecoder().decode([Map].self, from: data)
		return decodedData
	}
	
}
