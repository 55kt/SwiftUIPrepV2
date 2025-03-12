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
