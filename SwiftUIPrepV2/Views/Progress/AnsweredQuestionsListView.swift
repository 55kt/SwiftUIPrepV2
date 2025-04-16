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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var notificationHandler = FavoriteNotificationHandler()
    
    let progressResult: ProgressResult?
    
    // MARK: - Computed Properties
    private var questionResults: [QuestionResult] {
        guard let progressResult = progressResult,
              let questionResults = progressResult.questionResults as? Set<QuestionResult> else {
            return []
        }
        return questionResults.sorted { ($0.question?.question ?? "") < ($1.question?.question ?? "") }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: progressResult?.date ?? Date())
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            List {
                ForEach(questionResults) { questionResult in
                    if let question = questionResult.question {
                        HStack {
                            let isCorrect = questionResult.isAnsweredCorrectly
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
                            } // NavigationLink
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                if !notificationHandler.isBannerActive {
                                    Button {
                                        toggleFavorite(for: question)
                                    } label: {
                                        Image(systemName: question.isFavorite ? "star.slash.fill" : "star.fill")
                                    }
                                    .tint(.yellow)
                                }
                            } // swipeActions
                        } // HStack
                        .listRowBackground(Color.clear)
                    } // if
                } // ForEach
            } // List
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
                            .fontWeight(.bold)
                    } // Button
                } // ToolbarItem
                
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Answered Questions")
                            .font(.caption)
                            .foregroundStyle(.primary)
                        Text(formattedDate)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    } // VStack
                } // ToolbarItem
            } // toolbar
            .enableNavigationGesture()
            
            // Banner at the top
            VStack {
                BannerView(
                    showBanner: $notificationHandler.showBanner,
                    isBannerActive: $notificationHandler.isBannerActive,
                    bannerType: notificationHandler.bannerType
                )
                Spacer()
            } // VStack
        } // ZStack
    } // body
    
    // MARK: - Helper Methods
    private func toggleFavorite(for question: Question) {
        notificationHandler.toggleFavorite(question, in: viewContext, allowRemoval: false)
    }
} // View

// MARK: - Preview
#Preview {
    let context = PersistenceController.preview.container.viewContext
    let coreDataRepository = CoreDataRepository(viewContext: context)
    let testViewModel = TestViewModel(coreDataRepository: coreDataRepository)
    return NavigationStack {
        AnsweredQuestionsListView(progressResult: nil)
            .environment(\.managedObjectContext, context)
            .environmentObject(testViewModel)
    }
}
