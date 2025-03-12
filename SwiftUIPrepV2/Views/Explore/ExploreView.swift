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
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 15) {
                    ForEach(categories, id: \.self) { category in
                        NavigationLink(destination: QuestionsListView(questions: ["Question 1"])
                            .navigationTitle("Data")
                            .navigationBarTitleDisplayMode(.inline)
                        ) {
                            CategoryCard(category: category, iconName: "api-icon")
                        }// NavigationLink
                    }// ForEach
                }// LazyVGrid
                .padding()
            }// ScrollView
            .navigationTitle("Explore")
        }// NavigationStack
        .foregroundStyle(.primary)
    }// Body
}// View

// MARK: - Preview
#Preview {
    ExploreView()
}
