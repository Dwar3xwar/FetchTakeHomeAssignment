import SwiftUI

struct RecipeItemModel {
    var recipeData: RecipeData? = nil
    var image: UIImage? = nil
    var service: IRecipeService
    
    init(
        recipeData: RecipeData?,
        service: IRecipeService
    ) {
        self.recipeData = recipeData
        self.service = service
    }
    
    @MainActor mutating func fetchImageData() async throws {
        guard let recipeData = recipeData else { return }
        do {
            self.image = try await self.service.fetchImage(for: recipeData)
        } catch {
            print(error, "error")
        }
    }
}

/// Used as a wrapper for a list item in the dynamic list.
/// It makes sure items are updated once additional data has been fetched.
final class RecipeListItemViewModel: Identifiable, ObservableObject {
    
    @Published var recipeItemModel: RecipeItemModel
    
    /// The index of the item in the list, starting from 0.
    var id: Int
    
    /// Has the fetch of additional data completed?
    var dataFetchComplete = false
    
    init(item: RecipeItemModel, index: Int) {
        self.recipeItemModel = item
        self.id = index
    }
    
    @MainActor func fetchAdditionalData() async {
        do {
            guard !dataFetchComplete else { return }
            try await recipeItemModel.fetchImageData()
            dataFetchComplete = true
        } catch {
            // handle error here
        }
    }
}
