//
//  BannerView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 12/4/25.
//

import SwiftUI

struct BannerView: View {
    // MARK: - Properties
    @Binding var showBanner: Bool
    @Binding var isBannerActive: Bool
    let message: String
    let color: Color
    
    @State private var offset: CGFloat = -100
    @State private var isVisible: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if isVisible {
                Text(message)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .offset(y: offset)
            }// if
        }// ZStack
        .onChange(of: showBanner) { oldValue, newValue in
            if newValue {
                isVisible = true
                withAnimation(.spring()) {
                    offset = 10
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.spring()) {
                        offset = -150
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isVisible = false
                        showBanner = false
                        isBannerActive = false
                    }// DispatchQueue
                }// DispatchQueue
            }// if
        }// onChange
    }// body
}// View

// MARK: - Preview
#Preview {
    BannerView(
        showBanner: .constant(true),
        isBannerActive: .constant(true),
        message: "Question added to favorites!",
        color: .green
    )
}
