//
//  AnsweredQuestionsListView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 10/3/25.
//

import SwiftUI
import CoreData

struct AnsweredQuestionsListView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    let progressResult: ProgressResult?
    
    private var questions: [Question] {
        guard let progressResult = progressResult,
              let questionResults = progressResult.questionResults as? Set<QuestionResult> else {
            return []
        }
        return questionResults.compactMap { $0.question }.sorted { $0.question < $1.question }
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
                        // Use iconName directly, with a fallback to "unknown-icon"
                        let iconName = question.iconName?.isEmpty == false ? question.iconName! : "unknown-icon"
                        QuestionListItemView(iconName: iconName, questionText: question.question)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            question.isFavorite.toggle()
                            do {
                                try viewContext.save()
                            } catch {
                                print("❌ Error saving isFavorite: \(error)")
                            }
                        } label: {
                            Image(systemName: question.isFavorite ? "star.slash.fill" : "star.fill")
                        }
                        .tint(.yellow)
                    }
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .background(MotionAnimationView())
        .toolbar {
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
                }
            }
        }
        .enableNavigationGesture()
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AnsweredQuestionsListView(progressResult: nil)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
