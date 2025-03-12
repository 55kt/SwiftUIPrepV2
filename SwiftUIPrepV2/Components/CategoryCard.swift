//
//  CategoryCard.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 12/3/25.
//

import SwiftUI

struct CategoryCard: View {
    // MARK: - Properties
    let category: String
    let iconName: String

    // MARK: - Body
    var body: some View {
        VStack {
            Image(iconName)
                .resizable()
                .frame(width: 80, height: 80)
            Text(category)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
        }// VStack
        .frame(width: 120, height: 160)
        .padding()
        .background(Material.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }// Body
}// View

// MARK: - Preview
#Preview {
    CategoryCard(category: "Data", iconName: "data-icon")
}
