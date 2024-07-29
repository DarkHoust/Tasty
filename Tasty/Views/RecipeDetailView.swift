import SwiftUI

struct RecipeDetailView: View {
    @StateObject private var networkManager = NetworkManager.shared
    var recipeId: Int

    @State private var recipeDetail: RecipeDetail?

    var body: some View {
        VStack {
            if let recipeDetail = recipeDetail {
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

                VStack(alignment: .leading) {
                    Text(recipeDetail.title)
                        .font(.largeTitle)
                        .padding(.top, 10)
                        .padding(.horizontal)
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Ingredients")
                                .font(.title2)
                                .padding(.bottom, 5)
                                .padding(.horizontal)

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
                                .padding(.horizontal)

                            Text(recipeDetail.instructions ?? "No instructions available")
                                .padding(.bottom, 5)
                                .padding(.horizontal)
                        }
                        .padding()
                    }
                }
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        print("Fetching details for recipeId: \(recipeId)")
                        networkManager.fetchRecipeDetail(recipeId: recipeId) { result in
                            if let result = result {
                                print("Successfully fetched recipe details.")
                                self.recipeDetail = result
                            } else {
                                print("Failed to fetch recipe details.")
                            }
                        }
                    }
            }
        }
        .onChange(of: recipeId) { newRecipeId in
            print("Recipe ID changed to: \(newRecipeId)")
            networkManager.fetchRecipeDetail(recipeId: newRecipeId) { result in
                if let result = result {
                    print("Successfully fetched recipe details for new ID.")
                    self.recipeDetail = result
                } else {
                    print("Failed to fetch recipe details for new ID.")
                }
            }
        }
        .padding()
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipeId: 123)
    }
}
