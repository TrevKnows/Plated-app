//
//  HomeViewModelTests.swift
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
                                    name: "Pepperpot",
                                    cuisine: "Guyanese",
                                    photoUrlSmall: "small.jpg",
                                    photoUrlLarge: "large.jpg",
                                    sourceUrl: "source.com",
                                    youtubeUrl: "youtube.com")
        mockNetworkManager.mockRecipes = [expectedRecipe]
        mockNetworkManager.shouldSucceed = true

        XCTAssertEqual(sut.recipesLoaded.count, 0, "Initial state should have no recipes loaded")

        // When
        try await sut.fetchRecipes(endpoint: RecipeAPI.fetchAllRecipes)
        print("Recipe Count: \(sut.recipesLoaded.count)")

        // Then
        XCTAssertEqual(sut.recipesLoaded.count, 1, "There should be one recipe loaded")
        XCTAssertEqual(sut.recipesLoaded.first, expectedRecipe, "The loaded recipe should match the expected recipe")
    }
    
    
    func testFailedRecipeFetch() async {
        // Given
        mockNetworkManager.shouldSucceed = false
        
        // When/Then
        do {
            try await sut.fetchRecipes(endpoint: RecipeAPI.fetchAllRecipes)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertTrue(mockNetworkManager.fetchDataCalled)
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testMalformedDataRecipeFetch() async {
        // Given
        mockNetworkManager.shouldSucceed = true
        mockNetworkManager.shouldReturnMalformedData = true

        // When/Then
        do {
            try await sut.fetchRecipes(endpoint: RecipeAPI.malformedData)
            XCTFail("Expected to throw a decoding error")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.decodingError)
        } catch {
            XCTFail("Expected APIError.decodingError, got \(error)")
        }
    }
    
    func testEmptyDataRecipeFetch() async throws {
        // Given
        mockNetworkManager.shouldSucceed = true
        mockNetworkManager.shouldReturnEmptyData = true

        // Assert initial state
        XCTAssertEqual(sut.recipesLoaded.count, 0, "Initial state should have no recipes loaded")

        // When
        try await sut.fetchRecipes(endpoint: RecipeAPI.emptyData)

        // Then
        XCTAssertEqual(sut.recipesLoaded.count, 0, "There should be no recipes loaded")
       
    }
    
}
