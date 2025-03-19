import SwiftUI

struct RecipeItemView: View {
    @ObservedObject var itemViewModel: RecipeListItemViewModel
    
    init(itemViewModel: RecipeListItemViewModel) {
        self.itemViewModel = itemViewModel
    }
    
    var body: some View {
        VStack {
            if let image = itemViewModel.recipeItemModel.image,
               let recipeData = itemViewModel.recipeItemModel.recipeData {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(recipeData.name)
                Text(recipeData.cuisine)
            }
        }
    }
}
