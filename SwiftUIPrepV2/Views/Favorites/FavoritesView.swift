//
//  FavoritesView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        // MARK: - Properties
        
        // MARK: - Body
        NavigationStack {
            List {
                ForEach(0 ..< 10) { index in
                    Text("Item \(index)")
                }// ForEach
            }// List
            .navigationTitle("Favorites")
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    FavoritesView()
}
