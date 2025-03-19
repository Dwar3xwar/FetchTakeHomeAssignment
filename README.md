
### Summary: Include screen shots or a video of your app highlighting its features

The app will first download all the recipe response but will only fetch 3 images at a time
On scroll when the last item on the List appears, it will batch the next set of images
https://github.com/user-attachments/assets/b655b809-5042-47e2-8d85-2620d049104a


The app will also show an empty state when the JSON is empty, prompting the user to retry again
https://github.com/user-attachments/assets/3773ec20-32e9-4f48-8b61-164d92266099


The app will also show an error state when the JSON is malformed, prompting the user to retry again
https://github.com/user-attachments/assets/d7010ab0-276c-4742-8fee-e8a61d315c72


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?


I primarily focused on building an architecture and unit testing portion of the project. 

For the architecture portion, I wanted to have a codebase that can easily scale, if the pagination was ever done on the server side. I try to keep the logic of pagination contained so I can easily swap out the implementation if I have to. This can be seen in the RecipeService. 

Also, I tried to break the project into logical modules such as the Networking Layer, UI Layer, and View Model Layers. This meant easy unit testing as I can test separate components individually.

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

