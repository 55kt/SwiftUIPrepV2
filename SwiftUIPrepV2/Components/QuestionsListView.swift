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
                    QuestionListItemView(iconName: "data-icon")
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
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.accent)
                        .font(.title2)
                        .bold()
                }
            }
            
            // MARK: - Navigation title
            ToolbarItem(placement: .principal) {
                HStack {
                    Image("data-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    Text("Loading & Somethingname ...")
                        .font(.caption)
                        .foregroundStyle(.primary)
                }// HStack
            }
        }// toolbar
        .enableNavigationGesture()
    }// Body
}// View

// MARK: - Preview
#Preview {
    NavigationStack {
        QuestionsListView(questions: ["Question 1", "Question 2", "Question 3"])
    }
}
