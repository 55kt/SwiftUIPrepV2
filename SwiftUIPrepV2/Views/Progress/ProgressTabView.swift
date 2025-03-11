//
//  ProgressTabView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct ProgressTabView: View {
    // MARK: - Properties
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: AnsweredQuestionsListView(questions: ["1"])) {
                    ProgressItemView(answeredQText: "You answered 10 out of 10 questions", time: "Your time is 12:32", date: Date(), medalColor: .yellow)
                }
                .listRowBackground(Color.clear)
            }// List
            .listStyle(.plain)
            .navigationTitle("Progress")
            .background(MotionAnimationView())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // action
                    } label: {
                        Image(systemName: "trash")
                            .font(.title2)
                    }
                }
            }// .toolbar
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    ProgressTabView()
}
