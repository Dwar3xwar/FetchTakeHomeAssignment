import Testing
@testable import FetchTakeHomeAssignment

@Suite("RecipeListModel Tests")
struct RecipeListModelTests {
    let recipeServiceSpy = RecipeServiceSpy()
    lazy var sut: RecipeListModel = {
        return RecipeListModel(service: recipeServiceSpy)
    }()
    
    @Test mutating func test_init_starts_pageIndex_from_negativeOne() {
        #expect(sut.pageIndex == -1)
    }
    
    @Test mutating func test_fetchNextItems_increments_pageIndex() async {
        #expect(sut.pageIndex == -1)
        let _ = await sut.fetchNextItems(count: 5)
        #expect(sut.pageIndex == 0)
        let _ = await sut.fetchNextItems(count: 5)
        #expect(sut.pageIndex == 1)
    }
    
    @Test mutating func test_fetchNextItems_callsRecipeServiceFetchPage() async {
        await #expect(recipeServiceSpy.didCallFetchPage == false)
        let _ = await sut.fetchNextItems(count: 5)
        await #expect(recipeServiceSpy.didCallFetchPage == true)
    }
}
