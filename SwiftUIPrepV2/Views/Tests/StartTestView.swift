//
//  StartTestView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct StartTestView: View {
    // MARK: - Properties
    @State private var numberOfQuestions = 10
    let questionOptions = Array(1...150)
    @State private var isButtonPulsating = false
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: - Header
                        VStack(spacing: 5) {
                            Text("Test")
                                .font(.largeTitle)
                                .bold()
                        }// VStack
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        // MARK: - Central content
                        VStack(spacing: 30) {
                            Text("Count of questions:")
                                .font(.title2)
                            
                            // MARK: - Wheel Picker
                            ZStack {
                                Image("ui-icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                                    .opacity(0.2)
                                
                                Picker("Number of questions", selection: $numberOfQuestions) {
                                    ForEach(questionOptions, id: \.self) { num in
                                        Text("\(num)")
                                            .tag(num)
                                            .font(.title)
                                    }// ForEach
                                }// Picker
                                .pickerStyle(.wheel)
                                .frame(height: 235)
                                .padding()
                                .clipShape(Circle())
                                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                            }// ZStack
                            .padding(.horizontal)
                            
                            // MARK: - Start test button
                            NavigationLink(destination: TestView()
                                .navigationBarBackButtonHidden(true)
                            ) {
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
                                    }
                            }// NavigationLink
                        }// VStack
                        .frame(maxHeight: .infinity, alignment: .center)
                    }// VStack
                    .padding()
                }// ScrollView
            }// GeometryReader
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    StartTestView()
}
