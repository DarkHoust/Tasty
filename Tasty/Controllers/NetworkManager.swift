import Foundation
import Alamofire

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()

    private let apiKey = "a1f3df8895834e7392ddc0aa26f9e6f7"
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

    func fetchRecipeDetail(recipeId: Int, completion: @escaping (RecipeDetail?) -> Void) {
            let endpoint = "\(baseURL)/recipes/\(recipeId)/information"
            let parameters: [String: Any] = [
                "apiKey": apiKey
            ]

            AF.request(endpoint, parameters: parameters).responseDecodable(of: RecipeDetail.self) { response in
                switch response.result {
                case .success(let result):
                    DispatchQueue.main.async {
                        completion(result)
                    }
                case .failure(let error):
                    // Optionally handle the error (e.g., log it or notify the user)
                    print("Failed to fetch recipe detail: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
}
