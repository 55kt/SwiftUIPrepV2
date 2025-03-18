//
//  ProgressBarLine.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 14/3/25.
//

import SwiftUI

struct ProgressBarLine: View {
    // MARK: - Proeprties
    let currentQuestion: Int
    let totalQuestions: Int
    
    var progress: Double {
        guard totalQuestions > 0 else { return 0.0 }
        return Double(currentQuestion) / Double(totalQuestions)
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                Text("Question 12 of 30")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Spacer()
            }// HStack
            
            ProgressView(value: progress)
                .tint(.accent)
                .frame(height: 12)
                .clipShape(Capsule())
        }// VStack
        .padding(.horizontal)
    }// Body
}// View

// MARK: - Preview
#Preview {
    ProgressBarLine(currentQuestion: 3, totalQuestions: 6)
}
