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
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: - Header
                    VStack(spacing: 5) {
                        Text("Test")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    } // VStack
                    
                    // MARK: - Central content
                    VStack {
                        Text("Count of questions:")
                            .font(.title2)
                        
                        // MARK: - Wheel Picker
                        PickerWheelView(numberOfQuestions: $numberOfQuestions)
                        
                        // MARK: - Start test button
                        NavigationLink {
                            // Navigate to TestView with the selected number of questions
                            TestView(numberOfQuestions: numberOfQuestions)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Circle()
                                .frame(height: 150)
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
                                }// onAppear
                        } // NavigationLink
                    } // VStack
                    .frame(maxHeight: .infinity, alignment: .center)
                } // VStack
                .padding()
            } // ScrollView
        } // NavigationStack
    } // body
}// View

// MARK: - Preview
#Preview {
    StartTestView()
}
