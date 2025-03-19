//
//  TestView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct TestView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @State private var isShowingStopAlert: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hourglass-icon")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.3)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        TimeRemainingHolder()
                            .padding()
                        
                        VStack(spacing: 20) {
                            ProgressBarLine(currentQuestion: 12, totalQuestions: 45)
                            
                            Text("What is a variable in Swift?")
                                .font(.title2)
                                .fontWeight(.heavy)
                            
                            AnswerCellButton(isCorrect: true, answerText: "") {}
                            AnswerCellButton(isCorrect: false, answerText: "") {}
                            AnswerCellButton(isCorrect: nil, answerText: "") {}
                            
                            Spacer()
                            
                        }// VStack
                        .padding()
                    }// VStack
                }// ScrollView
                .navigationTitle("Current Test")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .destructive) {
                            isShowingStopAlert = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "wrongwaysign.fill")
                                .font(.title2)
                                .bold()
                        }
                    }
                }// toolbar
                .alert("Stop Test?", isPresented: $isShowingStopAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Stop", role: .destructive) {
                        // action
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                } message: {
                    Text("Are you sure you want to stop the test? All progress will be lost. !")
                }// alert
            }
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    TestView()
}
