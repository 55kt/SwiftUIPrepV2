//
//  AnsweredQuestionsListView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 10/3/25.
//

import SwiftUI

struct AnsweredQuestionsListView: View {
    // MARK: - Properties
    let questions: [String]
    @Environment(\.dismiss) var dismiss
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    // MARK: - Body
    var body: some View {
        List {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)
                
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
            }// HStack
            .listRowBackground(Color.clear)
            
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                
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
            }// HStack
            .listRowBackground(Color.clear)
        }// List
        .navigationBarBackButtonHidden(true)
        .listStyle(.plain)
        .background(MotionAnimationView())
        .toolbar {
            
            // MARK: - Navigation title
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
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .bold()
                }
            }
        }// toolbar
        .enableNavigationGesture()
    }// Body
}// View

#Preview {
    NavigationStack {
        AnsweredQuestionsListView(questions: ["Question 1", "Question 2", "Question 3"])
    }
}
