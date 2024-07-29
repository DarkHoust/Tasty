import SwiftUI

struct RecipeCard: View {
    let result: Result
    @State private var isBookmarked: Bool = false
    @State private var loadedImage: UIImage? = nil

    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipeId: result.id)) {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    if let image = loadedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .clipped()
                            .cornerRadius(10)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 180)
                            .cornerRadius(10)
                            .onAppear {
                                loadImage(from: result.image)
                            }
                    }
                    
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(1)]), startPoint: .top, endPoint: .bottom)
                        .frame(height: 100)
                        .cornerRadius(10)
                    
                    HStack {
                        Text(result.title)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding([.leading, .bottom], 15)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            isBookmarked.toggle()
                            saveBookmark()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 30, height: 30)
                                                                    
                                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                    .foregroundColor(isBookmarked ? .red : .black)
                            }
                        }
                        .padding([.trailing, .bottom], 15)
                    }
                }
            }
            .background(Color(.systemBackground)) // Ensure background is set
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top)
            .onAppear {
                isBookmarked = checkIfBookmarked()
            }
        }
        .buttonStyle(PlainButtonStyle()) // Prevents default link button styling
        .contentShape(Rectangle()) // Ensures the whole area is tappable
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.loadedImage = image
            }
        }.resume()
    }

    private func checkIfBookmarked() -> Bool {
        let bookmarks = UserDefaults.standard.object(forKey: "bookmarks") as? Data
        let decodedBookmarks = try? JSONDecoder().decode([Result].self, from: bookmarks ?? Data())
        return decodedBookmarks?.contains(where: { $0.id == result.id }) ?? false
    }

    private func saveBookmark() {
        let bookmarks = UserDefaults.standard.object(forKey: "bookmarks") as? Data
        var decodedBookmarks = (try? JSONDecoder().decode([Result].self, from: bookmarks ?? Data())) ?? []

        if isBookmarked {
            decodedBookmarks.append(result)
        } else {
            decodedBookmarks.removeAll { $0.id == result.id }
        }

        if let encodedBookmarks = try? JSONEncoder().encode(decodedBookmarks) {
            UserDefaults.standard.set(encodedBookmarks, forKey: "bookmarks")
        }
    }
}
