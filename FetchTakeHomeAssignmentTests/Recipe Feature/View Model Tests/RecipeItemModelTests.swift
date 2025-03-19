import Testing
@testable import FetchTakeHomeAssignment

@Suite("RecipeItemModel Tests")
struct RecipeItemModelTests {
    let recipeServiceSpy = RecipeServiceSpy()
    lazy var sut: RecipeItemModel = {
        return RecipeItemModel(
            recipeData: RecipeData.init(id: "abc", cuisine: "ab", name: "name", imageURLString: nil),
            service: recipeServiceSpy
        )
    }()
    
    @Test mutating func test_fetchImageData_() async throws {
        await #expect(recipeServiceSpy.didCallFetchImage == false)
        let _ = try await sut.fetchImageData()
        await #expect(recipeServiceSpy.didCallFetchImage == true)
    }
}
