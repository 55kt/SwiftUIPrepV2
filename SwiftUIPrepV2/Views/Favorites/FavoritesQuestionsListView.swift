//
//  FavoritesQuestionsListView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 18/3/25.
//

import SwiftUI

struct FavoritesQuestionsListView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isShowingStopAlert: Bool = false
    
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.question, ascending: true)],
        predicate: NSPredicate(format: "isFavorite == true")
    ) private var questions: FetchedResults<Question>
    
    // Function to update isFavorite for a single question
    private func updateFavoriteStatus(for question: Question, isFavorite: Bool) {
        question.isFavorite = isFavorite
        do {
            try viewContext.save()
            print(isFavorite ?
                  "💾 Added to favorites: \(question.question) 💾" :
                    "🗑️ Removed question from favorites: \(question.question) 🗑️")
        } catch {
            print("❌ Error updating isFavorite: \(error) ❌")
        }
    }
    
    // Function to delete all selected questions
    private func deleteAllFavorites() {
        for question in questions {
            updateFavoriteStatus(for: question, isFavorite: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismiss()
        }
    }
    
    // MARK: - Body
    var body: some View {
        List {
            ForEach(questions) { question in
                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                    
                    NavigationLink(
                        destination: QuestionDetailView(question: question),
                        label: {
                            let iconName = question.iconName ?? "unknown-icon"
                            QuestionListItemView(iconName: iconName, questionText: question.question)
                        }
                    )
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            updateFavoriteStatus(for: question, isFavorite: false)
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }// swipe
                }// HStack
                .listRowBackground(Color.clear)
            }// ForEach
        }// List
        .listStyle(.plain)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    isShowingStopAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.title2)
                        .bold()
                }
            }
        }// toolbar
        .alert("Delete all favorites ?", isPresented: $isShowingStopAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteAllFavorites()
            }
        } message: {
            Text("Are you sure you want to delete all favorites questions ? All questions will be lost. !")
        }// alert
        .enableNavigationGesture()
    }// Body
}// View

#Preview {
    NavigationStack {
        FavoritesQuestionsListView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
