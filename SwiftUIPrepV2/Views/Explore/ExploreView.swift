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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var searchText: String = ""
    @State private var selectedCategory: Category?
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) private var categories: FetchedResults<Category>
    
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.questionDescription, ascending: true)],
        predicate: NSPredicate(format: "category != nil")
    ) private var allQuestions: FetchedResults<Question>
    
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
    
    // Dynamic grid layout based on orientation
    private var gridLayout: [GridItem] {
        if horizontalSizeClass == .regular {
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        } else {
            return [GridItem(.flexible()), GridItem(.flexible())]
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background image
                    Image("explore-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(geometry.size.width * 0.7, 350), height: min(geometry.size.height * 0.7, 350))
                        .opacity(0.2)
                        .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                    
                    // Main content
                    ScrollView(.vertical, showsIndicators: false) {
                        Group {
                            if isSearchActive {
                                SearchResultsView(questions: filteredQuestions)
                            } else {
                                CategoriesView(
                                    gridLayout: gridLayout,
                                    categories: Array(categories),
                                    selectedCategory: $selectedCategory
                                )
                            }
                        } // if - else group
                        .padding(.horizontal, horizontalSizeClass == .regular ? 32 : 16) // Larger padding in landscape
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
                    } // if
                } // navigationDestination
            } // GeometryReader
        } // NavigationStack
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search for some question")        
        .foregroundStyle(.primary)
    } // body
} // View

// MARK: - Preview
#Preview {
    ExploreView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
