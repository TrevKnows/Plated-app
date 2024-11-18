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
    
    func fetchData<T: Decodable>(for endpoint: any API, responseType: T.Type) async throws -> T {
        fetchDataCalled = true
        if shouldSucceed {
            return mockRecipes as! T
        } else {
            throw APIError.networkError
        }
    }
}
