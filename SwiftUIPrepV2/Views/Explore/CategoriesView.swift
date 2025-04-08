//
//  CategoriesView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 24/3/25.
//

import SwiftUI
import CoreData

struct CategoriesView: View {
    // MARK: - Properties
    let gridLayout: [GridItem]
    let categories: [Category]
    @Binding var selectedCategory: Category?
    
    // MARK: - Body
    var body: some View {
        LazyVGrid(columns: gridLayout, alignment: .center, spacing: 15) {
            ForEach(categories) { category in
                CategoryCard(category: category.name, iconName: category.iconName)
                    .onTapGesture {
                        print("Tapped on category: \(category.name), questions count: \((category.questions?.allObjects as? [Question])?.count ?? 0)")
                        selectedCategory = category
                    }// onTapGesture
            }// ForEach
        }// LazyVGrid
        .padding()
    }// body
}// View
