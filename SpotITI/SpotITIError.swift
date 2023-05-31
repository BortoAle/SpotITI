//
//  SpotITIError.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 20/05/23.
//

import Foundation

enum SpotITIError: Error {
	// Throw when the URL cannot be created
	case urlError
	// Throw when server is not responding
	case serverError
	// Throw in all other cases
	case unexpected(code: Int)
}

extension SpotITIError: CustomStringConvertible {
	public var description: String {
		switch self {
			case .urlError:
				return "Cannot create an URL object"
			case .serverError:
				return "Server not reachable"
			case .unexpected(let code):
				return "Unexpected error: code\(code)"
		}
	}
}
