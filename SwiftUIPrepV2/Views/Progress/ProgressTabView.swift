//
//  ProgressTabView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

struct ProgressTabView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var testViewModel: TestViewModel
    @State private var isShowingStopAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(
        entity: ProgressResult.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ProgressResult.date, ascending: false)]
    ) private var progressResults: FetchedResults<ProgressResult>
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("progress-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .opacity(0.4)
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                
                // Progress list
                List {
                    ForEach(progressResults) { progressResult in
                        NavigationLink {
                            // Navigate to AnsweredQuestionsListView for the selected progress result
                            AnsweredQuestionsListView(progressResult: progressResult)
                        } label: {
                            ProgressItemView(
                                answeredQText: "You answered \(progressResult.correctAnswers) out of \(progressResult.totalQuestions) questions",
                                time: "Correct: \(String(format: "%.1f", testViewModel.calculateCorrectPercentage(for: progressResult)))%",
                                date: progressResult.date ?? Date(),
                                medalColor: testViewModel.calculateMedalColor(for: progressResult)
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
                                .fontWeight(.bold)
                        } // Button
                    } // ToolbarItem
                } // toolbar
                .alert("Delete Progress?", isPresented: $isShowingStopAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        testViewModel.deleteAllProgressResults(progressResults: Array(progressResults))
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete your progress? This action cannot be undone.")
                } // alert
            } // ZStack
        } // NavigationStack
    } // body
} // View

// MARK: - Preview
#Preview {
    ProgressTabView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(TestViewModel())
} // Preview
