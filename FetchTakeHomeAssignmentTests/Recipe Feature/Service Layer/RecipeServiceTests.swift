import Foundation
import UIKit
import Testing
@testable import FetchTakeHomeAssignment

actor MockNetworkManager<DecodableItem: Decodable>: INetworkManager {
    var fileURL: URL
    var didCallDataFunction: Bool = false
    var didCallDecodedDataFunction: Bool = false

    init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func data(from url: URL) async throws -> Data {
        let path = fileURL
        let data = try Data(contentsOf: path, options: .mappedIfSafe)
        self.didCallDataFunction = true
        return data
    }
    
    func decodedData<T>(from url: URL) async throws -> T where T : Decodable {
        let path = fileURL
        let data = try Data(contentsOf: path, options: .mappedIfSafe)
        self.didCallDecodedDataFunction = true
        return try JSONDecoder().decode(DecodableItem.self, from: data) as! T
    }
}

actor RecipeCacheSpy: IRecipeCacheService {
    
    var cache: [String: UIImage] = [:]
    
    init(cache: [String : UIImage], didCallGet: Bool = false) {
        self.cache = cache
    }
    
    func add(image: UIImage, id: String) async {
        
    }
    
    func remove(id: String) async {
        
    }
    
    func get(id: String) async -> UIImage? {
        return cache[id]
    }
}

@Suite("Recipe Service")
class RecipeServiceTests {
    static let recipeResponseDataSuccess = Bundle(for: RecipeServiceTests.self).url(forResource: "recipedatasucess", withExtension: "json")!
    static let imageDataSuccess = Bundle(for: RecipeServiceTests.self).url(forResource: "testImage", withExtension: "jpg")!
    
    @Suite("imageFetch")
    struct ImageFetchTests {
        // TODO: Fix Unit tests
        @Suite struct NoCache {
            let recipe = RecipeData(id: "abc", cuisine: "x", name: "y", imageURLString: "asdsaasdads")
            let mockNetworkManagerSuccess = MockNetworkManager<Data>(fileURL: RecipeServiceTests.imageDataSuccess)
            let cache = RecipeCacheSpy.init(cache: [:])
            
            @Test func test_RecipeService_imageFetch_usesNetworkManagerWhenCacheIsNotAvaliable() async throws {
                let sut = RecipeService(networkManager: mockNetworkManagerSuccess, cache: cache)
                try await sut.fetchImage(for: recipe)
                await #expect(mockNetworkManagerSuccess.didCallDataFunction == true)
            }
        }
        
        @Suite struct ActiveCache {
            let recipe = RecipeData(id: "abc", cuisine: "x", name: "y", imageURLString: "asdsaasdads")
            let mockNetworkManagerSuccess = MockNetworkManager<Data>(fileURL: RecipeServiceTests.imageDataSuccess)
            let cache = RecipeCacheSpy.init(cache: ["abc": UIImage(systemName: "heart.fill")!])
            
            lazy var sut = {
                RecipeService(networkManager: mockNetworkManagerSuccess, cache: cache)
            }()
            
            @Test mutating func test_RecipeService_imageFetch_usesCacheWhenAvaliable() async throws {
                let result = try await sut.fetchImage(for: recipe)
                await #expect(mockNetworkManagerSuccess.didCallDataFunction == false)
                #expect(result == UIImage(systemName: "heart.fill"))
            }
        }
        
        @Suite("imageFetch: Recipe URL Tests")
        struct RecipeHasNilURLValue {
            @Test func test_returns_nil() async throws {
                let mockNetworkManagerSuccess = MockNetworkManager<Data>(fileURL: RecipeServiceTests.imageDataSuccess)
                let sut = RecipeService(networkManager: mockNetworkManagerSuccess)
                let recipe = RecipeData(id: "abc", cuisine: "x", name: "y", imageURLString: nil)
                let result = try await sut.fetchImage(for: recipe)
                #expect(result == nil)
            }
            
            @Test func test_RecipeService_imageFetch_badURLValueReturnsNil() async throws {
                let mockNetworkManagerSuccess = MockNetworkManager<Data>(fileURL: RecipeServiceTests.imageDataSuccess)
                let sut = RecipeService(networkManager: mockNetworkManagerSuccess)

                let recipe = RecipeData(id: "abc", cuisine: "x", name: "y", imageURLString: "")
                let result = try await sut.fetchImage(for: recipe)
                #expect(result == nil)
            }
        }
        
        @Suite("fetchRecipes(seperatedBy batchCount: Int)")
        struct FetchRecipesTests {
            let mockNetworkManagerSuccess = MockNetworkManager<RecipeDataResponse>(fileURL: RecipeServiceTests.recipeResponseDataSuccess)
            
            @Test func test_should_update_recipeData_value_from_json() async throws {
                let sut = RecipeService(networkManager: mockNetworkManagerSuccess)
                let batchCount = 5
                try await sut.fetchRecipes(seperatedBy: batchCount, with: .success)
                let result = await sut.recipeData
                
                #expect(result != nil)
                
                // JSON has 64 counts
                // Batch each chunk by 5
                // Expect to have chunked into 12 chunks
                #expect(result?.count == 12)
            }
        }
        
        @Suite("fetch(page: Int) ")
        struct FetchPageTests {
            init() async throws {
                // Setup
                let mockNetworkManagerSuccess = MockNetworkManager<RecipeDataResponse>(fileURL: RecipeServiceTests.recipeResponseDataSuccess)
                let sut = RecipeService(networkManager: mockNetworkManagerSuccess)
                let batchCount = 5
                try await sut.fetchRecipes(seperatedBy: batchCount, with: .success)
            }
            
            lazy var sut: RecipeService = {
                RecipeService.init(networkManager: mockNetworkManagerSuccess)
            }()
            
            let mockNetworkManagerSuccess = MockNetworkManager<RecipeDataResponse>(fileURL: RecipeServiceTests.recipeResponseDataSuccess)
            
            @Test mutating func test_fetch_page_doesNotExceedTotalPages() async throws {
                let totalPages = await sut.recipeData?.count ?? 0
                let result = await sut.fetch(page: totalPages + 1)
                #expect(result == [])
            }
        }
    }
}


