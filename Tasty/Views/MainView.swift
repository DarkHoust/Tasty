//
//  MainView.swift
//  Tasty
//
//  Created by Sultan on 18.07.2024.
//


import SwiftUI

struct MainView: View {
    @StateObject private var networkManager = NetworkManager.shared

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Hello, User")
                    .font(.largeTitle)
                    .bold()
                    .frame(width: .infinity, alignment: .leading)
                    .padding(.top, 16)

                Text("What are you cooking today?")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                ScrollView {
                    LazyVStack {
                        ForEach(networkManager.recipes, id: \.id) { recipe in
                            RecipeCard(result: recipe)
                        }
                    }
                }
            }
            .frame(width: .infinity)
            .padding(.horizontal)
            .onAppear {
                networkManager.searchRecipes(query: "")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

