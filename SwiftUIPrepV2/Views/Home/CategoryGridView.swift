//
//  CategoryGridView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 5/3/25.
//

import SwiftUI

struct CategoryGridView: View {
    // MARK: - Properties
    let gridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 15) {
                    ForEach(0 ..< 15) { category in
                        NavigationLink(destination: QuestionDetailView()) {
                            CategoryGridItemView()
                        }// NavigationLink
                    }// ForEach
                }// LazyVGrid
                .padding()
            }// ScrollView
        }// NavigationStack
    }// Body
}// View

// MARK: - Properties
#Preview {
    CategoryGridView()
}
