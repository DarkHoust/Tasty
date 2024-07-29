import SwiftUI

struct BookmarkView: View {
    @State private var bookmarks: [Result] = []

    var body: some View {
        VStack(alignment: .leading) {
            Text("Bookmarks")
                .font(.largeTitle)
                .bold()
                .padding(.top, 16)

            ScrollView {
                LazyVStack {
                    ForEach(bookmarks, id: \.id) { result in
                        RecipeCard(result: result)
                            .background(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                print("Recipe Card tapped: \(result.title)")
                            }
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            bookmarks = getBookmarks()
        }
    }

    private func getBookmarks() -> [Result] {
        if let savedBookmarks = UserDefaults.standard.object(forKey: "bookmarks") as? Data {
            if let decodedBookmarks = try? JSONDecoder().decode([Result].self, from: savedBookmarks) {
                return decodedBookmarks
            }
        }
        return []
    }
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView()
    }
}
