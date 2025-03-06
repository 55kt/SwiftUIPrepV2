//
//  CategoryGridItemView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 4/3/25.
//

import SwiftUI

struct CategoryGridItemView: View {
    // MARK: - Properties
    
    // MARK: - Body
    var body: some View {
        VStack {
            Image("data-icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("DATA")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
        }// VStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    CategoryGridItemView()
}
