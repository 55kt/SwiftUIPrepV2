//
//  ExploreView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct ExploreView: View {
    // MARK: - Properties
    let categories = ["Data", "Math", "Science", "History", "Geography", "Art", "Literature", "Solid & somethingnamed "]
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Image("explore-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .opacity(0.4)
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 15) {
                        ForEach(categories, id: \.self) { category in
                            NavigationLink(destination: QuestionsListView(questions: ["Question 1"])
                                .navigationTitle("Data")
                                .navigationBarTitleDisplayMode(.inline)
                            ) {
                                CategoryCard(category: category, iconName: "data-icon")
                            }// NavigationLink
                        }// ForEach
                    }// LazyVGrid
                    .padding()
                }// ScrollView
                .navigationTitle("Explore")
            }// ZStack
        }// NavigationStack
        .searchable(text: .constant(""), prompt: "Search for some question")
        .foregroundStyle(.primary)
    }// Body
}// View

// MARK: - Preview
#Preview {
    ExploreView()
}
