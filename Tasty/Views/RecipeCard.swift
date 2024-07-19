import SwiftUI

struct RecipeCard: View {
    let result: Result
    @State private var isBookmarked: Bool = false

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
    }
    
    private func loadImage(from urlString: String) -> UIImage {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return UIImage(systemName: "photo")!
        }
        return image
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(result: Result(id: 1, title: "Asian Soft Scrambled Eggs", image: "https://img.spoonacular.com/recipes/632884-312x231.jpg", imageType: .jpg))
    }
}
