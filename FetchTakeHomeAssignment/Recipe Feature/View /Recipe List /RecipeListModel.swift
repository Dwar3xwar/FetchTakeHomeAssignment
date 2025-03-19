import SwiftUI

struct RecipeListModel {
    var pageIndex = -1
    
    let recipeService: IRecipeService
    
    init(
        service: IRecipeService
    ) {
        self.recipeService = service
    }
    
    mutating func fetchNextItems(count: Int) async -> [RecipeItemModel] {
        // ask service for the next items to fetch by count
        pageIndex += 1
        return await recipeService.fetch(page: pageIndex)
            .map { RecipeItemModel(recipeData: $0, service: recipeService) }
    }
    
    mutating func reset() {
        pageIndex = -1
    }
}


/// Acts as the view model for the dynamic list.
/// Handles fetching (and storing) the next batch of items as needed.
final class RecipeListViewModel: ObservableObject {
    
    enum ViewState {
        case loading
        case empty
        case error
        case list
    }
    
    @MainActor @Published private(set) var viewState: ViewState = .loading
    @MainActor @Published private(set) var list: [RecipeListItemViewModel] = []
    @MainActor @Published private(set) var fetchingInProgress: Bool = false
        
    private var listModel: RecipeListModel
    private let itemBatchSize: Int
    
    private(set) var listID: UUID = UUID()
    
    private var recipeService: IRecipeService
    
    init(
        listModel: RecipeListModel = RecipeListModel(service: RecipeService.shared),
        itemBatchCount: Int = 3,
        recipeService: IRecipeService = RecipeService.shared
    ) {
        self.listModel = listModel
        self.itemBatchSize = itemBatchCount
        self.recipeService = recipeService
    }
    
    @MainActor func fetchUpItemData(with url: RecipeService.RecipeURLStrings) async {
        do {
            try await recipeService.fetchRecipes(seperatedBy: itemBatchSize, with: url)
            guard await !recipeService.isRecipeListEmpty() else {
                self.viewState = .empty
                return
            }
            self.viewState = .list
        } catch {
            self.viewState = .error
        }
    }
    
    /// Extend the list if we are close to the end, based on the specified index
    @MainActor func fetchMoreItemsIfNeeded(currentIndex: Int) async {
        guard currentIndex >= list.count - 1,
                !fetchingInProgress
        else { return }
        fetchingInProgress = true
        let newItems = await listModel.fetchNextItems(count: itemBatchSize)
        let newListItems = newItems.enumerated().map { (index, item) in
            RecipeListItemViewModel(item: item, index: list.count + index)
        }
        
        // TODO: Optimize by parallel excuting fetchAdditionalData() by potentially using TaskGroup or AsyncSequence ??
        for listItem in newListItems {
            list.append(listItem)
            Task {
                await listItem.fetchAdditionalData()
            }
        }
                        
        fetchingInProgress = false
    }
    
    /// Reset to start fetching batches from the beginning.
    ///
    /// Called when the list is refreshed.
    @MainActor func reset() {
        guard !fetchingInProgress else { return }
        list = []
        listID = UUID()
        listModel.reset()
    }
}
