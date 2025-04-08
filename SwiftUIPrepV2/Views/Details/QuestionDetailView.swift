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
    
    // MARK: - Initialization
    // Initializes the view with a question and sets the initial favorite status
    init(question: Question) {
        self.question = question
        self._isFavorite = State(initialValue: question.isFavorite)
    }
    
    // MARK: - body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // Question header with icon and category
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
            } // ToolbarItem
        } // toolbar
    } // body
    
    // MARK: - Helper Methods
    // Toggles the favorite status of the question and saves the context
    private func toggleFavorite() {
        isFavorite.toggle()
        question.isFavorite = isFavorite
        do {
            try viewContext.save()
        } catch {
            print("❌ Error saving isFavorite: \(error)") // delete this code in final commit
        }
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
} // Preview
