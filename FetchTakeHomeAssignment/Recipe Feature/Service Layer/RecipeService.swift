import SwiftUI
import Algorithms

protocol IRecipeService {
    func isRecipeListEmpty() async -> Bool
    
    func fetchRecipes(seperatedBy batchCount: Int, with: RecipeService.RecipeURLStrings) async throws
    func fetch(page: Int) async -> [RecipeData]
    func fetchImage(for recipe: RecipeData) async throws -> UIImage?
}

actor RecipeService: IRecipeService {
    enum RecipeURLStrings: String {
        case success = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        case empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    }
    
    static let shared = RecipeService()
    let cache: IRecipeCacheService
    let networkManager: INetworkManager
    
    init(
        networkManager: INetworkManager = NetworkManager.shared,
        cache: IRecipeCacheService = RecipeCacheService()
    ) {
        self.networkManager = networkManager
        self.cache = cache
    }
    
    private(set) var recipeData: EvenlyChunkedCollection<[RecipeData]>?
    
    func isRecipeListEmpty() async -> Bool {
        return recipeData?.isEmpty ?? true
    }
    
    func fetchRecipes(seperatedBy batchCount: Int, with url: RecipeURLStrings) async throws {
        guard let url = URL.init(string: url.rawValue) else { return }
        let recipeResponse: RecipeDataResponse = try await networkManager.decodedData(from: url)
        let pages = recipeResponse.recipes.count / batchCount
        let chunked = recipeResponse.recipes.evenlyChunked(in: pages)
        self.recipeData = chunked
    }
    
    func fetch(page: Int) async -> [RecipeData] {
        guard let chunkedRecipeData = self.recipeData,
              let startIndex = recipeData?.startIndex,
              let totalPages = recipeData?.count
        else { return [] }
        
        guard page < totalPages else { return [] }
       
        return Array(
            chunkedRecipeData[chunkedRecipeData.index(startIndex, offsetBy: page)]
        )
    }
    
    func fetchImage(for recipe: RecipeData) async throws -> UIImage? {
        if let cachedImage = await cache.get(id: recipe.id) {
            return cachedImage
        }
        guard let imageUrl = recipe.imageURLString else { return nil }
        guard let urlString = URL.init(string: imageUrl) else { return nil }
        let data: Data = try await networkManager.data(from: urlString)
        guard let image = UIImage(data: data) else { return nil }
        await cache.add(image: image, id: recipe.id)
        return image
    }
}

