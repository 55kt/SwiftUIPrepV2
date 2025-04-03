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
    @State private var isShowingStopAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(
        entity: ProgressResult.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ProgressResult.date, ascending: false)]
    ) private var progressResults: FetchedResults<ProgressResult>
    
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
                    ForEach(progressResults) { progressResult in
                        NavigationLink {
                            AnsweredQuestionsListView(progressResult: progressResult)
                        } label: {
                            ProgressItemView(
                                answeredQText: "You answered \(progressResult.correctAnswers) out of \(progressResult.totalQuestions) questions",
                                time: "Correct: \(String(format: "%.1f", calculateCorrectPercentage(for: progressResult)))%",
                                date: progressResult.date ?? Date(),
                                medalColor: calculateMedalColor(for: progressResult)
                            )
                        }
                        .listRowBackground(Color.clear)
                    } // ForEach
                } // List
                .listStyle(.plain)
                .navigationTitle("Progress")
                .background(MotionAnimationView())
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingStopAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .font(.title2)
                                .bold()
                        }
                    }
                } // toolbar
                .alert("Delete Progress ?", isPresented: $isShowingStopAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        for progressResult in progressResults {
                            viewContext.delete(progressResult)
                        }
                        do {
                            try viewContext.save()
                            print("🗑️ Progress reset successfully 🗑️")
                        } catch {
                            print("❌ Error resetting progress: \(error) ❌")
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                } message: {
                    Text("Are you sure you want to delete your progress? This action cannot be undone.")
                } // alert
            } // ZStack
        } // NavigationStack
    } // body
    
    // MARK: - Helper Methods
    private func calculateCorrectPercentage(for progressResult: ProgressResult) -> Double {
        guard progressResult.totalQuestions > 0 else { return 0.0 }
        return (Double(progressResult.correctAnswers) / Double(progressResult.totalQuestions)) * 100
    }
    
    private func calculateMedalColor(for progressResult: ProgressResult) -> Color {
        let percentage = calculateCorrectPercentage(for: progressResult)
        if percentage >= 80 {
            return .yellow
        } else if percentage >= 50 {
            return .gray
        } else {
            return .brown
        }
    }
} // View

// MARK: - Preview
#Preview {
    ProgressTabView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
