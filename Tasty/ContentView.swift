//
//  ContentView.swift
//  Tasty
//
//  Created by Sultan on 12.07.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Main", systemImage: "house")
                }
            IngredientsView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            BookmarkView()
                .tabItem {
                    Label("Favorite", systemImage: "bookmark")
                }
        }
        
        
    }
}

#Preview {
    ContentView()
}
