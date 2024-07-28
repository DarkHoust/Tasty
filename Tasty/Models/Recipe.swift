// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let recipe = try? JSONDecoder().decode(Recipe.self, from: jsonData)

import Foundation

// MARK: - Recipe
struct Recipe: Codable {
    let results: [Result]
    let offset, number, totalResults: Int
}

// MARK: - Result
struct Result: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let imageType: ImageType
}

enum ImageType: String, Codable {
    case jpg = "jpg"
}
