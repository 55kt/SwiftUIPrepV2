//
//  FavoritesView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct FavoritesView: View {
    // MARK: - Properties
    @State private var favoriteQuestions: [String] = [
        "What is a variable in Swift?",
        "How to create a struct in Swift?",
        "What is an enum in Swift?"
    ] // Заглушка для избранных вопросов
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Background Icon
                Image("favorites-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .opacity(0.4)
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                
                FavoritesQuestionsListView(questions: ["1", "2"])
                
                
            }// ZStack
            .navigationTitle("Favorites")
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    FavoritesView()
}
