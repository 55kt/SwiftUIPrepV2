//
//  QuestionListItemView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct QuestionListItemView: View {
    // MARK: - Properties
    let iconName: String
    let questionText: String
    
    
    // MARK: - Body
    var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
            
            Text(questionText)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
        }// HStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    QuestionListItemView(iconName: "data-icon", questionText: "What is a variable ?")
}
