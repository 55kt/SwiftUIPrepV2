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
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: Date())
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
                    
                    NavigationLink(destination: QuestionDetailView(question: question)) {
                        QuestionListItemView(iconName: question.iconName, questionText: question.question)
                    }// NavigationLink
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            question.isFavorite = false
                            do {
                                try viewContext.save()
                                print("🗑️ Removed question from favorites: \(question.question) 🗑️")
                            } catch {
                                print("❌ Error removing question from favorites: \(error) ❌")
                            }
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                }// HStack
                .listRowBackground(Color.clear)
            }// ForEach
        }// List
        .listStyle(.plain)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Favorites")
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
                do {
                    try viewContext.save()
                    print("🗑️ All favorites deleted successfully")
                } catch {
                    print("❌ Error deleting all favorites: \(error)")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    dismiss()
                }
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
