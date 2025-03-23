//
//  ExploreView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

struct ExploreView: View {
    // MARK: - Properties
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) private var categories: FetchedResults<Category>
    
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
                        ForEach(categories) { category in
                            let questions = (category.questions?.allObjects as? [Question]) ?? []
                            let destination = QuestionsListView(categoryName: category.name, questions: questions)
                                .navigationTitle(category.name)
                                .navigationBarTitleDisplayMode(.inline)
                            
                            NavigationLink(destination: destination) {
                                CategoryCard(category: category.name, iconName: category.iconName)
                            }// NavigationLink
                        }// ForEach
                    }// LazyVGrid
                    .padding()
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
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
