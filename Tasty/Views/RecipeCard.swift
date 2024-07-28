import SwiftUI

struct RecipeCard: View {
    let result: Result
    @State private var isBookmarked: Bool = false
    @State private var showDetailView: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                Image(uiImage: loadImage(from: result.image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(10)
                
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
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.top)
        .onAppear {
            isBookmarked = checkIfBookmarked()
        }
        .onTapGesture {
            showDetailView = true
        }
        .sheet(isPresented: $showDetailView) {
            RecipeDetailView(recipeId: result.id)
        }
    }
    
    private func loadImage(from urlString: String) -> UIImage {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return UIImage(systemName: "photo")!
        }
        return image
    }

    private func checkIfBookmarked() -> Bool {
        let bookmarks = UserDefaults.standard.object(forKey: "bookmarks") as? Data
        let decodedBookmarks = try? JSONDecoder().decode([Result].self, from: bookmarks ?? Data())
        return decodedBookmarks?.contains(where: { $0.id == result.id }) ?? false
    }

    private func saveBookmark() {
        var bookmarks = UserDefaults.standard.object(forKey: "bookmarks") as? Data
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
