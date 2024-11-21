//
//  RecipeListState.swift
//  Plated
//
//  Created by Trevor Beaton on 11/20/24.
//

import Foundation

enum RecipeListState {
    case loading
    case loaded([Recipe])
    case empty
    case error(Error)
}
