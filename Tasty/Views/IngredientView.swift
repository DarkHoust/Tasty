import SwiftUI

struct IngredientsView: View {
    @State private var ingredients: [String] = []
    @State private var newIngredient: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Text("What ingredients do you have?")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.leading)
                    .padding()

                List {
                    ForEach(ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                    }
                    .onDelete(perform: deleteIngredient)
                    
                    HStack {
                        TextField("Add Ingredient", text: $newIngredient)
                        Button(action: {
                            if !newIngredient.isEmpty {
                                ingredients.append(newIngredient)
                                newIngredient = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

                NavigationLink {
                    RecipeResultsView(ingredients: ingredients)
                } label: {
                    Text("Search Recipes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView()
    }
}
