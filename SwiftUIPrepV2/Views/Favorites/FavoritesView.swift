//
//  FavoritesView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass // For adapting to orientation
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // MARK: - Background Icon
                    Image("favorites-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(geometry.size.width * 0.7, 350), height: min(geometry.size.height * 0.7, 350))
                        .opacity(0.4)
                        .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                    
                    // List of favorite questions
                    FavoritesQuestionsListView()
                        .padding(.horizontal, horizontalSizeClass == .regular ? 32 : 16) // Larger padding in landscape
                } // ZStack
                .navigationTitle("Favorites")
            } // GeometryReader
        } // NavigationStack
    } // body
} // View

// MARK: - Preview
#Preview {
    FavoritesView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
} // Preview
