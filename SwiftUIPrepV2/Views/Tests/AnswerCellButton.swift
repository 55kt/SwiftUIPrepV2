//
//  AnswerCellButton.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 14/3/25.
//

import SwiftUI

struct AnswerCellButton: View {
    // MARK: - Properties
    var isCorrect: Bool? = nil
    let answerText: String
    var action: () -> Void
    
    @State private var isTapped: Bool = false
    
    private var background: LinearGradient {
        if let isCorrect = isCorrect {
            return isCorrect ? ButtonGradients.correctAnswer : ButtonGradients.incorrectAnswer
        }
        return ButtonGradients.defaultButton
    }
    
    // MARK: - Body
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                isTapped = true
            }
        } label: {
            Text("Variable in Swift is a data type that can hold any value of a certain type.")
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(background)
                        .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                )
                .foregroundStyle(.white)
                .scaleEffect(isTapped ? 0.95 : 1.0)
                .animation(.easeInOut, value: isTapped)
        }
    }// Body
}// View

// MARK: - Preview
#Preview {
    VStack(spacing: 10) {
        AnswerCellButton(isCorrect: true, answerText: "Correct Answer") {}
        AnswerCellButton(isCorrect: false, answerText: "Incorrect Answer") {}
        AnswerCellButton(answerText: "Default Button") {}
    }
    .padding()
}
