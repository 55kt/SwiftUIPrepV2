//
//  HeadingView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 4/3/25.
//

import SwiftUI

struct HeadingView: View {
    // MARK: - Properties
    let headingImage: String
    let headingText: LocalizedStringKey
    let headingColor: Color
    
    // MARK: - Body
    var body: some View {
        HStack {
            Image(systemName: headingImage)
                .foregroundStyle(headingColor)
                .imageScale(.large)
            
            Text(headingText)
                .font(.title3)
                .fontWeight(.bold)
        }// HStack
        .padding(.vertical)
    }// Body
}// View

// MARK: - Preview
#Preview {
    HeadingView(headingImage: "photo.on.rectangle.angled", headingText: "Code in pictures", headingColor: Color.accent)
}
