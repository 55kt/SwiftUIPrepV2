//
//  AnsweredQuestionsListView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 10/3/25.
//

import SwiftUI

struct AnsweredQuestionsListView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.question, ascending: true)],
        predicate: NSPredicate(format: "isAnswered == true")
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
                    let isCorrect = question.isAnsweredCorrectly ?? false
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(question.isAnsweredCorrectly ?? false ? .green : .red)
                    
                    NavigationLink(destination: QuestionDetailView(question: question)) {
                        QuestionListItemView(iconName: question.iconName, questionText: question.question)
                        
                        
                    }// NavigationLink
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            question.isFavorite.toggle()
                            do {
                                try viewContext.save()
                                print("💾 Saved isFavorite: \(question.isFavorite) for question: \(question.question) 💾")
                            } catch {
                                print("❌ Error saving isFavorite: \(error)")
                            }
                        } label: {
                            Image(systemName: question.isFavorite ? "star.slash.fill" : "star.fill")
                        }
                        .tint(.yellow)
                    }// swipe
                }// HStack
                .listRowBackground(Color.clear)
            }// ForEach
        }// List
        .listStyle(.plain)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .background(MotionAnimationView())
        .toolbar {
            // MARK: - Navigation title
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .bold()
                }
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Answered Questions")
                        .font(.caption)
                        .foregroundStyle(.primary)
                    Text(formattedDate)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }// VStack
            }
        }// toolbar
        .enableNavigationGesture()
    }// Body
}// View

#Preview {
    NavigationStack {
        AnsweredQuestionsListView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
