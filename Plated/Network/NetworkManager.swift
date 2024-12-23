//
//  NetworkManager.swift
//  Plated
//
//  Created by Trevor Beaton on 11/17/24.
//

import Foundation

/// Enum representing common errors that may occur during networking.
enum APIError: LocalizedError {
    case networkError
    case decodingError

    /// Provides a user-readable description of the error.
    var errorDescription: String? {
        switch self {
        case .networkError:
            return NSLocalizedString("Unable to return data from network request", comment: "API returned an error")
        case .decodingError:
            return NSLocalizedString("Unable to decode", comment: "Review data models and the JSON they're trying to decode")
        }
    }
}

struct APIResponse<T: Decodable>: Decodable {
    let recipes: T
}

protocol NetworkManaging {
    /// Fetches data for the recipe and custom URL API endpoint and decodes it into the given type
    /// - Parameters:
    ///   - endpoint: The API endpoint to fetch data from.
    ///   - responseType: The expected type of the decoded response.

    func fetchData<T: Decodable>(for endpoint: API, responseType: T.Type) async throws -> T
}

/// The network manager responsible for executing API requests.
final class NetworkManager: NetworkManaging {
    /// Builds the relevant URL components from the values specified in the API.
    /// - Parameter endpoint: The API endpoint containing the URL components.
    /// - Returns: A `URLComponents` object representing the full URL.
    /// - Throws: `CommonError.invalidURL` if the components are invalid.
    private class func buildURL(endpoint: API) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path

        guard components.scheme != nil, components.host != nil, components.path != "" else {
            throw APIError.decodingError
        }

        return components
    }

    /// Fetches data for a specified API endpoint and decodes it into the given type.
    /// - Parameters:
    ///   - endpoint: The API endpoint to fetch data from.
    ///   - responseType: The type of object expected in the response.
    /// - Returns: A decoded object of the specified type.
    /// - Throws: `APIError` if the request fails or the response cannot be decoded.
    func fetchData<T: Decodable>(for endpoint: API, responseType: T.Type) async throws -> T {
        
        let urlComponents = try Self.buildURL(endpoint: endpoint)

        guard let url = urlComponents.url else {
            throw APIError.decodingError
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            // Perform request
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.networkError
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.networkError
            }

            // Print response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }

            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
            return apiResponse.recipes
     
        } catch let error as APIError {
            
            throw error
            
        } catch {
            throw APIError.decodingError
        }
    }
}

extension DecodingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .typeMismatch(_, let context),
             .valueNotFound(_, let context),
             .keyNotFound(_, let context),
             .dataCorrupted(let context):
            return "Data corruption error: \(context.debugDescription)"
        @unknown default:
            return "An unknown decoding error occurred."
        }
    }
}
