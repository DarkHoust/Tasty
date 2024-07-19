//
//  RecipeListView.swift
//  Tasty
//
//  Created by Sultan on 12.07.2024.
//

import Foundation
import SwiftUI

struct RecipesListView: View {
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            TextField("Search recipes", text: $searchText, onCommit: {
                networkManager.searchRecipes(query: searchText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            List(networkManager.recipes, id: \.id) { recipe in
                VStack(alignment: .leading) {
                    Text(recipe.title)
                    // Display other recipe information as needed
                }
            }
        }
    }
}

#Preview {
    RecipesListView()
}
