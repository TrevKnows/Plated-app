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
    
    func testInitialState() {
        // Then
        if case .loading = sut.state {

        } else {
            XCTFail("Initial state should be .loading")
        }
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
        
        // When
        try await sut.fetchRecipes(endpoint: RecipeAPI.fetchAllRecipes)
        
        // Then
        guard case let .loaded(recipes) = sut.state else {
            XCTFail("State should be .loaded")
            return
        }
        
        XCTAssertEqual(recipes.count, 1, "There should be one recipe loaded")
        XCTAssertEqual(recipes.first, expectedRecipe, "The loaded recipe should match the expected recipe")
    }
    
    func testEmptyStateRecipeFetch() async throws {
        // Given
        mockNetworkManager.shouldSucceed = true
        mockNetworkManager.shouldReturnEmptyData = true
        
        // When
        try await sut.fetchRecipes(endpoint: RecipeAPI.emptyData)
        
        // Then
        guard case .empty = sut.state else {
            XCTFail("State should be .empty")
            return
        }
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
            
            guard case .error(let stateError) = sut.state else {
                XCTFail("State should be .error")
                return
            }
            
            XCTAssertTrue(stateError is APIError)
            XCTAssertEqual(stateError as? APIError, .networkError)
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
        } catch {
            guard case .error(let stateError) = sut.state else {
                XCTFail("State should be .error")
                return
            }
            
            XCTAssertTrue(stateError is APIError)
            XCTAssertEqual(stateError as? APIError, .decodingError)
        }
    }
    
    func testStateTransitionsDuringFetch() async throws {
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
        
        // Initially should be loading
        if case .loading = sut.state {
            // Test passes
        } else {
            XCTFail("Initial state should be .loading")
        }
        
        // When
        try await sut.fetchRecipes(endpoint: RecipeAPI.fetchAllRecipes)
        
        // Then should be loaded with data
        guard case .loaded = sut.state else {
            XCTFail("Final state should be .loaded")
            return
        }
    }
}
