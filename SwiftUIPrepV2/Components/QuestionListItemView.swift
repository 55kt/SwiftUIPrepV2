//
//  QuestionListItemView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct QuestionListItemView: View {
    // MARK: - Properties
    @State var iconName: String = ""
    
    // MARK: - Body
    var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed venenatis pretium dapibus.?")
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
        }// HStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    QuestionListItemView(iconName: "data-icon")
}
