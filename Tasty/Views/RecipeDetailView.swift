//
//  RecipeDetailView.swift
//  Tasty
//
//  Created by Sultan on 28.07.2024.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject private var networkManager = NetworkManager.shared
    var recipeId: Int

    var body: some View {
        VStack {
            if let recipeDetail = networkManager.recipeDetail {
                Text(recipeDetail.title)
                    .font(.largeTitle)
                    .padding()
                
                // Add other detailed view components for the recipe here
                // For example: Image, ingredients, instructions, etc.
                
                ScrollView {
                    VStack(alignment: .leading) {
                        if let imageUrl = URL(string: recipeDetail.image) {
                                            AsyncImage(url: imageUrl) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 250)
                                                        .clipped()
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 250)
                                                        .clipped()
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        }
                        
                        Text("Ingredients")
                            .font(.title2)
                            .padding(.bottom, 5)
                        
                        VStack(alignment: .leading) {
                                                    ForEach(recipeDetail.extendedIngredients, id: \.id) { ingredient in
                                                        HStack(alignment: .top) {
                                                            Text("•")
                                                            Text(ingredient.original)
                                                        }
                                                        .padding(.bottom, 2)
                                                    }
                                                }
                        
                        Text("Instructions")
                            .font(.title2)
                            .padding(.top, 10)
                        
                        Text(recipeDetail.instructions ?? "No instructions available")
                            .padding(.bottom, 5)
                    }
                    .padding()
                }
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        networkManager.fetchRecipeDetail(recipeId: recipeId)
                    }
            }
        }
        .padding()
    }
}
