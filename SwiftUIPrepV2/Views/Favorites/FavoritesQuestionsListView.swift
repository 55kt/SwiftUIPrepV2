//
//  FavoritesQuestionsListView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 18/3/25.
//

import SwiftUI
import CoreData

struct FavoritesQuestionsListView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isShowingStopAlert: Bool = false
    
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.question, ascending: true)],
        predicate: NSPredicate(format: "isFavorite == true")
    ) private var questions: FetchedResults<Question>
    
    // MARK: - Helper Methods
    // Updates the favorite status of a single question and saves the context
    private func updateFavoriteStatus(for question: Question, isFavorite: Bool) {
        question.isFavorite = isFavorite
        do {
            try viewContext.save()
        } catch {
            print("❌ Error updating isFavorite: \(error)") // delete this code in final commit
        }
    }
    
    // Deletes all favorite questions and dismisses the view
    private func deleteAllFavorites() {
        for question in questions {
            updateFavoriteStatus(for: question, isFavorite: false)
        }
        dismiss()
    }
    
    // MARK: - body
    var body: some View {
        List {
            ForEach(questions) { question in
                HStack {
                    // Favorite icon
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                    
                    // Navigate to question details
                    NavigationLink {
                        QuestionDetailView(question: question)
                    } label: {
                        let iconName = question.iconName ?? "unknown-icon"
                        QuestionListItemView(iconName: iconName, questionText: question.question)
                    } // NavigationLink
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            updateFavoriteStatus(for: question, isFavorite: false)
                        } label: {
                            Image(systemName: "trash.fill")
                        } // Button
                    } // swipeActions
                } // HStack
                .listRowBackground(Color.clear)
            } // ForEach
        } // List
        .listStyle(.plain)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    isShowingStopAlert = true
                } label: {
                    Image(systemName: "trash")
                        .font(.title2)
                        .fontWeight(.bold)
                } // Button
            } // ToolbarItem
        } // toolbar
        .alert("Delete all favorites?", isPresented: $isShowingStopAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteAllFavorites()
            } // Button
        } message: {
            Text("Are you sure you want to delete all favorites questions? All questions will be lost!")
        } // alert
        .enableNavigationGesture() // Custom modifier for navigation gestures
    } // body
}

// MARK: - Preview
#Preview {
    NavigationStack {
        FavoritesQuestionsListView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    } // NavigationStack
} // Preview
