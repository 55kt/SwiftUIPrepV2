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
    
    let progressResult: ProgressResult?
    
    private var questions: [Question] {
            guard let progressResult = progressResult,
                  let questionResults = progressResult.questionResults as? Set<QuestionResult> else {
                print("⚠️ progressResult or questionResults is nil")
                return []
            }
            let questions = questionResults.compactMap { $0.question }.sorted { $0.question < $1.question }
            print("🔍 Loaded \(questions.count) questions for progressResult with date: \(progressResult.date?.description ?? "unknown")")
            return questions
        }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: progressResult?.date ?? Date())
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
                        .foregroundStyle(isCorrect ? .green : .red)
                    
                    NavigationLink {
                        QuestionDetailView(question: question)
                    } label: {
                        QuestionListItemView(iconName: question.iconName, questionText: question.question)
                    } // NavigationLink
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
                    } // swipe
                } // HStack
                .listRowBackground(Color.clear)
            } // ForEach
        } // List
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
                } // VStack
            }
        } // toolbar
        .enableNavigationGesture()
    } // body
} // View

// MARK: - Preview
#Preview {
    NavigationStack {
        AnsweredQuestionsListView(progressResult: nil)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
