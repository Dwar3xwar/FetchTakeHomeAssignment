import SwiftUI

struct RecipeListView: View {
    @ObservedObject var listViewModel: RecipeListViewModel
    var body: some View {
        VStack {
            switch listViewModel.viewState {
            case .loading:
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case .empty:
                VStack {
                    Text("Nothing here")
                    Button("Retry") {
                        Task {
                            listViewModel.reset()
                            await self.listViewModel.fetchUpItemData(with: .success)
                        }
                    }
                }
            case .error:
                VStack {
                    Text("Something went wrong")
                    Button("Retry") {
                        Task {
                            listViewModel.reset()
                            await self.listViewModel.fetchUpItemData(with: .success)
                        }
                    }
                }
            case .list:
                ScrollViewReader { proxy in
                    List(listViewModel.list) { itemViewModel in
                        RecipeItemView(itemViewModel: itemViewModel)
                            .task {
                                await self.listViewModel.fetchMoreItemsIfNeeded(currentIndex: itemViewModel.id)
                            }
                    }
                    .refreshable {
                        listViewModel.reset()
                    }
                    .task {
                        await self.listViewModel.fetchMoreItemsIfNeeded(currentIndex: 0)
                    }
                    .id(self.listViewModel.listID)
                }
            }
        }.task {
            // Initial Loading of the View
            // Change this parameter for the initial load
            // success -> Gives Good Json
            // malformed -> Gives Malformed Json
            // empty -> Gives Empty Json
            await self.listViewModel.fetchUpItemData(with: .success)
        }
    }
}
