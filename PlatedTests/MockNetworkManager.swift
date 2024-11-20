//
//  MockNetworkManager.swift
//  PlatedTests
//
//  Created by Trevor Beaton on 11/17/24.
//

import XCTest
@testable import Plated

class MockNetworkManager: NetworkManaging {
    var shouldSucceed = true
    var mockRecipes: [Recipe] = []
    var fetchDataCalled = false
    var shouldReturnMalformedData = false
    var shouldReturnEmptyData = false

    func fetchData<T: Decodable>(for endpoint: API, responseType: T.Type) async throws -> T {
        fetchDataCalled = true
        print("fetchData called with endpoint: \(endpoint), shouldSucceed: \(shouldSucceed)")

        if shouldSucceed {
           /// FLAG: - // Simulates malformed data
            if shouldReturnMalformedData {
                throw APIError.decodingError
            }
            
            if shouldReturnEmptyData {
                /// FLAG: - Simulates empty data
                if let result = [] as? T {
                    return result
                } else {
                    fatalError("Type mismatch: expected \(T.self), got empty array")
                }
            }
            // Makes sure the type matches the mockRecipes type
            if let result = mockRecipes as? T {
                return result
            } else {
                fatalError("Type mismatch: expected \(T.self), got \(type(of: mockRecipes))")
            }
        } else {
            throw APIError.networkError
        }
    }
}
