//
//  StartTestView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct StartTestView: View {
    // MARK: - Properties
    @State private var numberOfQuestions: Int = 10
    let questionOptions: [Int] = Array(10...150)
    @State private var isButtonPulsating: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // MARK: - Central content
                        VStack(spacing: 20) {
                            Text("Count of questions:")
                                .font(.title2)
                            
                            // MARK: - Wheel Picker
                            PickerWheelView(numberOfQuestions: $numberOfQuestions)
                                .frame(maxWidth: min(geometry.size.width * 0.8, 400))
                            
                            // MARK: - Start test button
                            NavigationLink {
                                TestView(numberOfQuestions: numberOfQuestions)
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                Circle()
                                    .frame(height: horizontalSizeClass == .regular ? 200 : 150)
                                    .overlay(
                                        Text("START")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    )
                                    .scaleEffect(isButtonPulsating ? 1.07 : 1.0)
                                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isButtonPulsating)
                                    .shadow(color: Color.gray.opacity(0.6), radius: 6, x: 0, y: 4)
                                    .onAppear {
                                        isButtonPulsating = true
                                    } // onAppear
                            } // NavigationLink
                        } // VStack
                        .padding(horizontalSizeClass == .regular ? 32 : 16)
                    } // VStack
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                } // ScrollView
                .navigationTitle("Test")
            } // GeometryReader
        } // NavigationStack
    } // body
} // View

// MARK: - Preview
#Preview {
    StartTestView()
}
