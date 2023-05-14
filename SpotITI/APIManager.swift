//
//  APIManager.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 14/05/23.
//

import Foundation

class APIManager {
	
	func fetchMaps() async -> [Map] {
		let url = URL(string: "http://192.168.1.2:3000/maps")!
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			let decodedData = try JSONDecoder().decode([Map].self, from: data)
			return decodedData
		} catch {
			print(error.localizedDescription)
		}
		return []
	}
	
}
