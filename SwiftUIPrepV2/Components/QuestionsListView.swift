//
//  QuestionsListView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 6/3/25.
//

import SwiftUI

struct QuestionsListView: View {
    // MARK: - Properties
    let categoryName: String
    let questions: [Question]
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - Body
    var body: some View {
        List {
            ForEach(questions) { question in
                NavigationLink(destination: QuestionDetailView(question: question)) {
                    QuestionListItemView(iconName: question.iconName, questionText: question.question)
                }// NavigationLink
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        if !question.isFavorite {
                            question.isFavorite = true
                            do {
                                try viewContext.save()
                                print("💾 Saved isFavorite: \(question.isFavorite) for question: \(question.question) 💾")
                            } catch {
                                print("❌ Error saving isFavorite: \(error) ❌")
                            }
                        }
                    } label: {
                        Image(systemName: "star.fill")
                    }
                    .tint(.yellow)
                }// swipe
            }// ForEach
        }// List
        .listStyle(.plain)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.accent)
                        .font(.title2)
                        .bold()
                }
            }
            
            // MARK: - Navigation title
            ToolbarItem(placement: .principal) {
                HStack {
                    (questions.first?.iconName != nil ?
                     Image(questions.first!.iconName) :
                        Image("unknown-icon"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    Text(categoryName)
                        .font(.caption)
                        .foregroundStyle(.primary)
                }// HStack
            }
        }// toolbar
        .enableNavigationGesture()
    }// Body
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
