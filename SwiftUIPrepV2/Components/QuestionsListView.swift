//
//  QuestionsListView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 6/3/25.
//

import SwiftUI
import CoreData

struct QuestionsListView: View {
    // MARK: - Properties
    let categoryName: String
    let questions: [Question]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    // MARK: - Helper Methods
    // Toggles the favorite status of a question to true and saves the context
    private func addToFavorites(_ question: Question) {
        if !question.isFavorite {
            question.isFavorite = true
            do {
                try viewContext.save()
            } catch {
                print("❌ Error saving isFavorite: \(error)") // delete this code in final commit
            }
        }
    }
    
    // MARK: - body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image based on the first question's icon
                Image(questions.first?.iconName ?? "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(geometry.size.width * 0.7, 350), height: min(geometry.size.height * 0.7, 350))
                    .opacity(0.2)
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                
                // List of questions
                List {
                    ForEach(questions) { question in
                        // Navigate to question details
                        NavigationLink {
                            QuestionDetailView(question: question)
                        } label: {
                            let iconName = question.iconName ?? "unknown-icon"
                            QuestionListItemView(iconName: iconName, questionText: question.question)
                        } // NavigationLink
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            // Add question to favorites
                            Button {
                                addToFavorites(question)
                            } label: {
                                Image(systemName: "star.fill")
                            } // Button
                            .tint(.yellow)
                        } // swipeActions
                    } // ForEach
                } // List
                .listStyle(.plain)
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Back button
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.accent)
                                .font(.title2)
                                .fontWeight(.bold)
                        } // Button
                    } // ToolbarItem
                    
                    // MARK: - Navigation title
                    ToolbarItem(placement: .principal) {
                        Text(categoryName)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    } // ToolbarItem
                } // toolbar
                .padding(.horizontal, horizontalSizeClass == .regular ? 32 : 6)
                .enableNavigationGesture() // Custom modifier for navigation gestures
            } // ZStack
        }
    } // body
}// View

// MARK: - Preview
#Preview {
    NavigationStack {
        QuestionsListView(
            categoryName: "Swift Basics",
            questions: []
        )
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
