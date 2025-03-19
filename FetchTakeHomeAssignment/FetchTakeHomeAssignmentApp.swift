//
//  FetchTakeHomeAssignmentApp.swift
//  FetchTakeHomeAssignment
//
//  Created by Eric Huang on 3/17/25.
//

import SwiftUI

@main
struct FetchTakeHomeAssignmentApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeListView(listViewModel: .init())
        }
    }
}
