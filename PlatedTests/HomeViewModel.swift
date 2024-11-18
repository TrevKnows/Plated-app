//
//  HomeViewModel.swift
//  PlatedTests
//
//  Created by Trevor Beaton on 11/17/24.
//

import XCTest
@testable import Plated

class HomeViewModelTests: XCTestCase {
    var sut: HomeViewModel!
    var mockNetworkManager: MockNetworkManager!
    
     override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        sut = HomeViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testSuccessfulRecipeFetch() async throws {
        // Given
        let expectedRecipe = Recipe(uuid: "000",
                                  name: "Test Recipe",
                                  cuisine: "Italian",
                                  photoUrlSmall: "small.jpg",
                                  photoUrlLarge: "large.jpg",
                                  sourceUrl: "source.com",
                                  youtubeUrl: nil)
      
        mockNetworkManager.mockRecipes = [expectedRecipe]
        mockNetworkManager.shouldSucceed = true
        
        // When
       try await sut.fetchRecipes()
        
        // Then
        XCTAssertTrue(mockNetworkManager.fetchDataCalled)
        XCTAssertEqual(sut.recipesLoaded.count, 1)
        XCTAssertEqual(sut.recipesLoaded.first, expectedRecipe)
    }
    
    func testFailedRecipeFetch() async {
        // Given
        mockNetworkManager.shouldSucceed = false
        
        // When/Then
        do {
            try await sut.fetchRecipes()
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertTrue(mockNetworkManager.fetchDataCalled)
            XCTAssertTrue(error is APIError)
        }
    }
}
