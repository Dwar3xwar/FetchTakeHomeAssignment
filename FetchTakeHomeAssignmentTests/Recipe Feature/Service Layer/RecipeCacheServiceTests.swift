import Testing
import SwiftUI
@testable import FetchTakeHomeAssignment

@Suite("RecipeCacheService Tests")
struct RecipeCacheServiceTests {
    @Test func recipeCacheService_add_get() async {
        let sut = RecipeCacheService()
        let id = "id"
        let image = UIImage(systemName: "heart.fill")!
        await sut.add(image: image, id: id)
        
        let result = await sut.get(id: id)
        #expect(image == result)
    }

    @Test func recipeCacheService_remove() async {
        let sut = RecipeCacheService()
        let id = "id"
        let image = UIImage(systemName: "heart.fill")!
        await sut.add(image: image, id: id)
        
        await sut.remove(id: id)
        let result = await sut.get(id: id)

        #expect(result == nil)
    }

}
