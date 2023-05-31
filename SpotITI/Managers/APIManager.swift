//
//  APIManager.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 14/05/23.
//

import Foundation

class APIManager: ObservableObject {
	
	@Published var classrooms: [Character: [Spot]] = [:]
	@Published var utilities: [Spot] = []
	@Published var categories: [Category] = []
	
	/// Return the best route given a start node Id and a destination Category
	@MainActor
	func getSpots() async throws {
		let url = "https://bussola.voceaglistudenti.ml/spots"
		let spots: [Spot] = try await fetchData(url: url)
		
		// Filters the classrooms from the utilities
		var classrooms = spots.filter({ !$0.category.type.isUtility })
		classrooms.sort(by: { $0.name < $1.name })
		
		// Categorizes the classrooms
		self.classrooms = categorizeClassrooms(classrooms: spots)
	}
	
	/// Return the best route given a start node Id and a destination Category
	@MainActor
	func getCategories() async throws {
		let url = "https://bussola.voceaglistudenti.ml/categories"
		
		let categories: [Category] = try await fetchData(url: url)
		
		// Filters the utilities from the classrooms
		self.categories = categories.filter({ $0.type.isUtility })
	}
	
	/// Return the best route given a start Node id and a destination Node id
	///
	/// - Parameter startNodeId: the Node id where the user is positioned
	/// - Parameter endNodeId: the destination Node id
	func getRoutes(startNodeId: Int, endNodeId: Int) async throws -> [Route] {
		let url = "https://bussola.voceaglistudenti.ml/routes/\(startNodeId)/\(endNodeId)"
		return try await fetchData(url: url)
	}
	
	/// Return the best route given a start node Id and a destination Spot
	///
	/// - Parameter startNodeId: the Node id where the user is positioned
	/// - Parameter endSpot: the destination Spot
	func getRoutes(startNodeId: Int, endSpot: Spot) async throws -> [Route] {
		let url = "https://bussola.voceaglistudenti.ml/routes/\(startNodeId)/spot/\(endSpot.id)"
		return try await fetchData(url: url)
	}
	
	/// Return the best route given a start node id and a destination Category
	///
	/// - Parameter startNodeId: the Node id where the user is positioned
	/// - Parameter endCategory: the destination Category
	func getRoutes(startNodeId: Int, endCategory: Category.CategoryType) async throws -> [Route] {
		let url = "https://bussola.voceaglistudenti.ml/routes/\(startNodeId)/category/\(endCategory.name)"
		return try await fetchData(url: url)
	}
	
	/// Categorizes classrooms into a dictionary with a key for every building and all the building classrooms as values
	///
	/// - Parameter classrooms: the classrooms to categorize
	private func categorizeClassrooms(classrooms: [Spot]) -> [Character: [Spot]] {
		
		var categorizedClassrooms: [Character: [Spot]] = [:]
		
		for classroom in classrooms {
			let key = classroom.name.first!

			// Se il dizionario non ha ancora un valore per questa chiave, inizializza un array vuoto.
			if categorizedClassrooms[key] == nil {
				categorizedClassrooms[key] = [Spot]()
			}

			// Aggiunge la classe all'array per questa chiave.
			categorizedClassrooms[key]?.append(classroom)
		}
		
		return categorizedClassrooms
	}
	
	func fetchData<T: Codable>(url: String) async throws -> [T] {
		guard let url = URL(string: url) else {
			throw SpotITIError.urlError
		}
		let (data, response) = try await URLSession.shared.data(from: url)
		if let httpResponse = response as? HTTPURLResponse {
				print("statusCode: \(httpResponse.statusCode)")
			}
		return try decodeData(from: data)
	}
	
}

extension APIManager {
	
	private func decodeData<T: Codable>(from data: Data) throws -> [T] {
		do {
			let decodedData = try JSONDecoder().decode([T].self, from: data)
			print(decodedData)
			return decodedData
		} catch {
			throw error
		}
	}
	
//
//	private func decodeSpots(from data: Data) throws -> [Spot] {
//		do {
//			let decodedData = try JSONDecoder().decode([Spot].self, from: data)
//			print(decodedData)
//			return decodedData
//		} catch {
//			throw SpotITIError.serverError
//		}
//	}
//
//	private func decodeRoutes(from data: Data) throws -> [Route] {
//		do {
//			let decodedData = try JSONDecoder().decode([Route].self, from: data)
//			print(decodedData)
//			return decodedData
//		} catch {
//			throw SpotITIError.serverError
//		}
//	}
	
}
