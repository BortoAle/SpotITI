//
//  APIManager.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 14/05/23.
//

import SwiftUI

class APIManager: ObservableObject {
	
	@Published var classrooms: [Character: [Spot]] = [:]
	@Published var utilities: [Spot] = []
	@Published var categories: [Category] = []
	
	/// Fetches available spots from the server and categorizes the classrooms.
	///
	/// This asynchronous method fetches the available spots from the server, filters out utilities from the spots to get the classrooms,
	/// and categorizes these classrooms.
	@MainActor
	func getSpots() async throws {
		let url = "https://bussola.voceaglistudenti.ml/spots"
		let spots: [Spot] = try await fetchData(url: url)
		
		// Filters the classrooms from the utilities
		var classrooms = spots.filter({ !$0.category.type.isUtility })
		classrooms.sort(by: { $0.name < $1.name })
		
		// Categorizes the classrooms
		withAnimation {
			self.classrooms = categorizeClassrooms(classrooms: spots)
		}
	}
	
	/// Fetches available categories from the server and filters out the utilities.
	///
	/// This asynchronous method fetches the available categories from the server and filters out utilities to get the needed categories.
	@MainActor
	func getCategories() async throws {
		let url = "https://bussola.voceaglistudenti.ml/categories"
		
		let categories: [Category] = try await fetchData(url: url)
		
		// Filters the utilities from the classrooms
		withAnimation {
			self.categories = categories.filter({ $0.type.isUtility })
		}
	}
	
	/// Fetches routes between the provided start and end node ids from the server.
	///
	/// This asynchronous method fetches the available routes between the provided start and end node ids from the server.
	///
	/// - Parameters:
	/// 	- startNodeId: The Node id where the user is positioned.
	/// 	- endNodeId: The destination Node id.
	func getRoutes(startNodeId: Int, endNodeId: Int) async throws -> [Route] {
		let url = "https://bussola.voceaglistudenti.ml/routes/\(startNodeId)/\(endNodeId)"
		return try await fetchData(url: url)
	}
	
	/// Fetches routes between the provided start node id and the destination Spot from the server.
	///
	/// This asynchronous method fetches the available routes between the provided start node id and the destination Spot from the server.
	///
	/// - Parameters:
	/// 	- startNodeId: The Node id where the user is positioned.
	/// 	- endSpot: The destination Spot.
	func getRoutes(startNodeId: Int, endSpot: Spot) async throws -> [Route] {
		let url = "https://bussola.voceaglistudenti.ml/routes/\(startNodeId)/spot/\(endSpot.id)"
		return try await fetchData(url: url)
	}
	
	/// Fetches routes between the provided start node id and the destination Category from the server.
	///
	/// This asynchronous method fetches the available routes between the provided start node id and the destination Category from the server.
	///
	/// - Parameters:
	/// 	- startNodeId: The Node id where the user is positioned.
	/// 	- endCategory: The destination Category.
	func getRoutes(startNodeId: Int, endCategory: Category.CategoryType) async throws -> [Route] {
		let url = "https://bussola.voceaglistudenti.ml/routes/\(startNodeId)/category/\(endCategory.name)"
		return try await fetchData(url: url)
	}
	
	/// Categorizes the provided classrooms into a dictionary where the keys are the first letters of the classroom names.
	///
	/// This method categorizes the provided classrooms into a dictionary.
	/// The keys of the dictionary are the first letters of the classroom names, and the correspondent values are the classrooms associated to that building
	///
	/// - Parameter classrooms: The classrooms to categorize.
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
	
	/// Fetches data from the server at the specified URL.
	///
	/// This asynchronous method fetches data from the server at the specified URL and decodes it into the provided generic type `T`.
	///
	/// - Parameter url: The URL string from where data should be fetched.
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
	
	/// Decodes JSON data into an array of a specified type.
	///
	/// This method attempts to decode the provided JSON data into an array of a specified `Codable` type `T`.
	/// If decoding fails, it throws the error that occurred during the process.
	///
	/// - Parameter data: The JSON data to decode.
	/// - Returns: An array of `T` if the decoding was successful.
	/// - Throws: An error if the decoding was unsuccessful.
	private func decodeData<T: Codable>(from data: Data) throws -> [T] {
		do {
			let decodedData = try JSONDecoder().decode([T].self, from: data)
			print(decodedData)
			return decodedData
		} catch {
			throw error
		}
	}
	
}
