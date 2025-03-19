
### Summary: Include screen shots or a video of your app highlighting its features

The app will first download all the recipe response but will only fetch 3 images at a time
On scroll when the last item on the List appears, it will batch the next set of images

https://github.com/user-attachments/assets/b655b809-5042-47e2-8d85-2620d049104a


The app will also show an empty state when the JSON is empty, prompting the user to retry again

https://github.com/user-attachments/assets/3773ec20-32e9-4f48-8b61-164d92266099


The app will also show an error state when the JSON is malformed, prompting the user to retry again

https://github.com/user-attachments/assets/d7010ab0-276c-4742-8fee-e8a61d315c72


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I primarily focused on the architecture of the project. I wanted the project to accomplish three things: 
            1) Meet the Project requirements
            2) Scalability 
            3) Unit testable

For the project requirements, I need to come up with some sort of client side pagination. I divided the logical parts of the codebase into components to support the pagination. 
            1) `RecipeListViewModel` is the engine for the feature. This would control when the data fetching happens and delegate the child view models                 when to fetch its own data. The main coordinater 
            2) `RecipeListModel` is the component which implements the function `fetchNextItems`. This function gets the next batch of items for the                     pagination
            3) `RecipeListItemViewModel` is the view model for each cell. It's main job is to fetch the Image file for the cell

For Scalability, I wanted to create a codebase that can easily swap out the implementation of the client side pagination for a server-side pagination implementation if it ever happens. This can be done by making a new class that conforms to the `IRecipeService`.

For Unit testability, I made sure to create interfaces for some of my actors/classes for my app. This will allow me to unit test these components in isolation and also utilize spies for better testing. 

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

Around 5-6 hours over 3 days. 

45 min: Research 
4 hours: Development 
1 hour: Unit testing + Regression Testing + Clean up

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

The major downfall of this project is the UI. It is barebones as I wanted to focus on the engine of the application. There are some loading indicators missing in some places. 

Another thing I didn’t have time to optimize was the batch image fetching. Currently the code looks like this:

```         for listItem in newListItems {
            list.append(listItem)
            Task {
                await listItem.fetchAdditionalData()
            }
        }
```

The app is running the batch fetchImage functions serially in time. I want to further optimize this by running them in parallel by utilizing Swift Concurrency, maybe TaskGroup or Async Sequence. 


### Weakest Part of the Project: What do you think is the weakest part of your project?

The weakest part is Documentation. I would’ve liked to add a bit more comments to help the readability of the project.

Another weak part is the structure of the Unit tests. Right now some files are a bit over the place.

