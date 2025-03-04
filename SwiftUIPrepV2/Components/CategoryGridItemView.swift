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
            Image("api-icon")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            Text("API")
                .font(.subheadline)
                .fontWeight(.bold)
        }// VStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    CategoryGridItemView()
}
