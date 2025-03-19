import Testing
import SwiftUI

@testable import FetchTakeHomeAssignment

actor RecipeServiceSpy: IRecipeService {
    
    var didCallIsRecipeListEmpty = false
    var didCallFetchRecipes = false
    var didCallFetchPage = false
    var didCallFetchImage = false

    func isRecipeListEmpty() async -> Bool {
        self.didCallIsRecipeListEmpty = true
        return false
    }
    
    func fetchRecipes(seperatedBy batchCount: Int, with: FetchTakeHomeAssignment.RecipeService.RecipeURLStrings) async throws {
        self.didCallFetchRecipes = true
    }
    
    func fetch(page: Int) async -> [FetchTakeHomeAssignment.RecipeData] {
        self.didCallFetchPage = true
        return []
    }
    
    func fetchImage(for recipe: FetchTakeHomeAssignment.RecipeData) async throws -> UIImage? {
        self.didCallFetchImage = true
        return nil
    }
}
