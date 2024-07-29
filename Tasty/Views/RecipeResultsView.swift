//
//  RecipeResultView.swift
//  Tasty
//
//  Created by Sultan on 12.07.2024.
//

import Foundation
import SwiftUI

struct RecipeResultsView: View {
    let ingredients: [String]

    @State private var recipes: [Result] = []
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(recipes, id: \.id) { recipe in
                            RecipeCard(result: recipe)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            searchRecipes()
        }
        .navigationTitle("Recipe Results")
    }

    private func searchRecipes() {
        isLoading = true
        let joinedIngredients = ingredients.joined(separator: ",")
        let apiKey = "a1f3df8895834e7392ddc0aa26f9e6f7"
        let urlString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apiKey)&query=\(joinedIngredients)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { isLoading = false }
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(Recipe.self, from: data)
                    DispatchQueue.main.async {
                        recipes = decodedResponse.results
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Network error: \(error)")
            }
        }.resume()
    }
}

struct RecipeResultsView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeResultsView(ingredients: ["Tomato", "Egg"])
    }
}
