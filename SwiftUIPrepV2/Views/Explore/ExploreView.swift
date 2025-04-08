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
    @Environment(\.dismiss) private var dismiss // For dismissing the view
    @Environment(\.managedObjectContext) private var viewContext // Core Data context
    @State private var searchText: String = "" // Search text input
    @State private var selectedCategory: Category? // Selected category for navigation
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) private var categories: FetchedResults<Category> // Fetches all categories
    
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.questionDescription, ascending: true)],
        predicate: NSPredicate(format: "category != nil")
    ) private var allQuestions: FetchedResults<Question> // Fetches questions with a category
    
    // MARK: - Computed Properties
    private var isSearchActive: Bool {
        !searchText.isEmpty
    }
    
    private var filteredQuestions: [Question] {
        // Filter questions based on search text
        guard isSearchActive else { return [] }
        let lowercaseSearchText = searchText.lowercased()
        return allQuestions.filter { question in
            question.question.lowercased().contains(lowercaseSearchText) ||
            question.questionDescription.lowercased().contains(lowercaseSearchText) ||
            question.correctAnswer.lowercased().contains(lowercaseSearchText) ||
            (question.incorrectAnswers?.contains { $0.lowercased().contains(lowercaseSearchText) } ?? false)
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("explore-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .opacity(0.2)
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                
                // Main content
                ScrollView(.vertical, showsIndicators: false) {
                    if isSearchActive {
                        SearchResultsView(questions: filteredQuestions)
                    } else {
                        CategoriesView(
                            gridLayout: gridLayout,
                            categories: Array(categories),
                            selectedCategory: $selectedCategory
                        )
                    }// if - else
                } // ScrollView
                .animation(.easeInOut(duration: 0.3), value: isSearchActive)
            } // ZStack
            .navigationTitle("Explore")
            .navigationDestination(isPresented: Binding(
                get: { selectedCategory != nil },
                set: { if !$0 { selectedCategory = nil } }
            )) {
                if let category = selectedCategory {
                    QuestionsListView(
                        categoryName: category.name,
                        questions: (category.questions?.allObjects as? [Question]) ?? []
                    )
                    .navigationTitle(category.name)
                    .navigationBarTitleDisplayMode(.inline)
                }// if
            } // navigationDestination
        } // NavigationStack
        .searchable(text: $searchText, prompt: "Search for some question")
        .foregroundStyle(.primary)
    } // body
}// View

// MARK: - Preview
#Preview {
    ExploreView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
