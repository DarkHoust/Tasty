import Foundation
import Alamofire

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()

    private let apiKey = "3ea9ae2782dd4ce9a2e6b41a5d56aea9"
    private let baseURL = "https://api.spoonacular.com"

    @Published var recipes: [Result] = []
    @Published var recipeDetail: RecipeDetail?

    func searchRecipes(query: String) {
        let endpoint = "\(baseURL)/recipes/complexSearch"
        let parameters: [String: Any] = [
            "apiKey": apiKey,
            "query": query
        ]

        AF.request(endpoint, parameters: parameters).responseDecodable(of: Recipe.self) { response in
            if let result = try? response.result.get() {
                DispatchQueue.main.async {
                    self.recipes = result.results
                }
            }
        }
    }

    func fetchRecipeDetail(recipeId: Int) {
        let endpoint = "\(baseURL)/recipes/\(recipeId)/information"
        let parameters: [String: Any] = [
            "apiKey": apiKey
        ]

        AF.request(endpoint, parameters: parameters).responseDecodable(of: RecipeDetail.self) { response in
            if let result = try? response.result.get() {
                DispatchQueue.main.async {
                    self.recipeDetail = result
                }
            }
        }
    }
}
