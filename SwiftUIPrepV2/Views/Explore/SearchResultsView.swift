//
//  SearchResultsView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 24/3/25.
//

import SwiftUI
import CoreData

struct SearchResultsView: View {
    // MARK: - Properties
    let questions: [Question]
    
    // MARK: - Body
    var body: some View {
        if questions.isEmpty {
            Text("No questions found")
                .font(.headline)
                .foregroundStyle(.gray)
                .padding()
        } else {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(questions) { question in
                    NavigationLink {
                        QuestionDetailView(question: question)
                            .navigationTitle(question.category?.name ?? "Unknown")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        QuestionListItemView(iconName: question.iconName, questionText: question.question)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }// NavigationLink
                }// ForEach
            }// LazyVStack
            .padding()
            .animation(.easeInOut(duration: 0.3), value: questions)
        }// if - else
    }// body
}// View
