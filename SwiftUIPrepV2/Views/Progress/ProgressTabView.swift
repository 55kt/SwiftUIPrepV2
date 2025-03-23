//
//  ProgressTabView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct ProgressTabView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.question, ascending: true)]
    ) private var questions: FetchedResults<Question>
    
    // MARK: - Progress calculation
    private var totalQuestions: Int {
        questions.count
    }
    
    private var answeredQuestions: Int {
        questions.filter { $0.isAnswered }.count
    }
    
    private var correctAnswers: Int {
        questions.filter { $0.isAnswered && ($0.isAnsweredCorrectly ?? false) }.count
    }
    
    private var correctPercentage: Double {
        guard answeredQuestions > 0 else { return 0.0 }
        return (Double(correctAnswers) / Double(answeredQuestions)) * 100
    }
    
    private var medalColor: Color {
        if correctPercentage >= 80 {
            return .yellow
        } else if correctPercentage >= 50 {
            return .gray
        } else {
            return .brown
        }
    }
    
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Image("progress-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .opacity(0.4)
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                
                List {
                    NavigationLink(destination: AnsweredQuestionsListView()) {
                        ProgressItemView(
                            answeredQText: "You answered \(answeredQuestions) out of \(totalQuestions) questions",
                            time: "Correct: \(String(format: "%.1f", correctPercentage))%",
                            date: Date(),
                            medalColor: medalColor
                        )
                    }
                    .listRowBackground(Color.clear)
                }// List
                .listStyle(.plain)
                .navigationTitle("Progress")
                .background(MotionAnimationView())
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            for question in questions {
                                question.isAnswered = false
                                question.isAnsweredCorrectlyRaw = nil
                            }
                            do {
                                try viewContext.save()
                                print("🗑️ Progress reset successfully 🗑️")
                            } catch {
                                print("❌ Error resetting progress: \(error) ❌")
                            }
                        } label: {
                            Image(systemName: "trash")
                                .font(.title2)
                                .bold()
                        }
                    }
                }// .toolbar
            }// ZStack
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    ProgressTabView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
