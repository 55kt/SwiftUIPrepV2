//
//  QuestionsListView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 6/3/25.
//

import SwiftUI

struct QuestionsListView: View {
    // MARK: - Properties
    let questions: [String]
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        List {
            ForEach(questions, id: \.self) { questions in
                NavigationLink(destination: QuestionDetailView()) {
                    QuestionListItemView(iconName: "loading-icon")
                }// NavigationLink
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        print("Added to favorites: \(questions)")
                    } label: {
                        Image(systemName: "star.fill")
                    }
                    .tint(.yellow)
                }// swipe
            }// ForEach
        }// List
        .listStyle(.plain)
    }// Body
}// View

// MARK: - Preview
#Preview {
    QuestionsListView(questions: ["Question 1", "Question 2", "Question 3"])
}
