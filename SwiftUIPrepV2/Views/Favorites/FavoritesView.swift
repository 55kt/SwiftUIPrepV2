//
//  FavoritesView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct FavoritesView: View {
    // MARK: - Properties
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
                
                FavoritesQuestionsListView()
            }// ZStack
            .navigationTitle("Favorites")
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    FavoritesView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
