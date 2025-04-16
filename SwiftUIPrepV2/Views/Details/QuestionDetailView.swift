//
//  QuestionDetailView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 4/3/25.
//

import SwiftUI
import CoreData

struct QuestionDetailView: View {
    // MARK: - Properties
    @ObservedObject var question: Question
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isFavorite: Bool
    @State private var needsRefresh: Bool = false
    @StateObject private var notificationHandler = FavoriteNotificationHandler()
    
    // MARK: - Initialization
    init(question: Question) {
        self.question = question
        self._isFavorite = State(initialValue: question.isFavorite)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    HStack {
                        Image(question.iconName ?? "unknown-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(question.category?.name ?? "Unknown")
                                .font(.title2)
                                .fontWeight(.heavy)
                        } // VStack
                    } // HStack
                    .padding(.horizontal)
                    .padding(.vertical)
                    
                    // Question details
                    VStack(alignment: .center, spacing: 0) {
                        // MARK: - Question
                        Section {
                            HeadingView(headingImage: "questionmark.bubble.fill", headingText: "Question", headingColor: .accent)
                            
                            Text(question.question)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .padding(.vertical, 8)
                        } // Question section
                        .padding(.horizontal)
                        
                        // MARK: - Answer
                        Section {
                            HeadingView(headingImage: "graduationcap.fill", headingText: "Answer", headingColor: .accent)
                            
                            Text(question.correctAnswer)
                                .font(.headline)
                                .padding(.horizontal)
                        } // Answer section
                        .padding(.horizontal)
                        
                        // MARK: - Description
                        Section {
                            VStack(alignment: .center, spacing: 2) {
                                HeadingView(headingImage: "info.circle.fill", headingText: LocalizedStringKey("Description"), headingColor: .accent)
                                
                                Text(question.questionDescription)
                                    .font(.headline)
                                    .padding(.horizontal)
                            } // VStack
                        } // Description section
                        .padding(.horizontal)
                    } // VStack
                } // VStack
                .padding(.bottom, 50)
            } // ScrollView
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // Back button
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.accent)
                            .font(.title2)
                            .fontWeight(.bold)
                    } // Button
                } // ToolbarItem
                
                // Favorite button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        toggleFavorite()
                    } label: {
                        Image(systemName: isFavorite ? "star.circle.fill" : "star.circle")
                            .foregroundStyle(isFavorite ? .yellow : .accent)
                            .font(.title2)
                            .fontWeight(.bold)
                    } // Button
                    .disabled(notificationHandler.isBannerActive)
                } // ToolbarItem
            } // toolbar
            .onReceive(NotificationCenter.default.publisher(for: NSManagedObjectContext.didChangeObjectsNotification)) { notification in
                if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
                   updatedObjects.contains(where: { $0.objectID == question.objectID }) {
                    isFavorite = question.isFavorite
                    print("🔍 QuestionDetailView: Detected change in question \(question.question), updated isFavorite to \(isFavorite)")
                }
            } // onReceive
            
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
    private func toggleFavorite() {
        let willRemoveFromFavorites = isFavorite
        notificationHandler.toggleFavorite(
            question,
            in: viewContext,
            allowRemoval: willRemoveFromFavorites
        )
    }
    
} // View

// MARK: - Preview
#Preview {
    NavigationStack {
        let context = PersistenceController.shared.container.viewContext
        let question = Question(context: context)
        question.question = "Sample Question"
        question.correctAnswer = "Sample Answer"
        question.questionDescription = "Sample Description"
        question.iconName = "unknown-icon"
        question.isFavorite = true
        return QuestionDetailView(question: question)
            .environment(\.managedObjectContext, context)
    } // NavigationStack
}
