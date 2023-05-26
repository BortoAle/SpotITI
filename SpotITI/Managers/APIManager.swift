//
//  APIManager.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 14/05/23.
//

import Foundation

class APIManager: ObservableObject {
	
	// Map properties
	@Published var vertices: [Vertex] = []
	
	func getRoutes(mapId: Int, startVertexId: Int, endVertexId: Int) async throws -> [Route] {
		guard let url = URL(string: "https://bussola.voceaglistudenti.ml/maps/3/routes/\(startVertexId)/\(endVertexId)") else {
			throw SpotITIError.serverError
		}
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			return try decodeRoutes(from: data)
		} catch {
			throw SpotITIError.serverError
		}

	}

	func decodeRoutes(from data: Data) throws -> [Route] {
		do {
			let decodedData = try JSONDecoder().decode([Route].self, from: data)
			print(decodedData)
			return decodedData
		} catch {
			throw SpotITIError.serverError
		}
	}
//
}
