//
//  ResultTestView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct ResultTestView: View {
    // MARK: - Properties
    @State private var isButtonPulsating = false
    @State private var showQuestionsList = false
    @Environment(\.dismiss) var dismiss
    
    private var scorePercentage: Double = 80.0
    
    private var medalDetails: (color: Color, text: String) {
        switch scorePercentage {
        case 80...100:
            return (.yellow, "Gold Medal")
        case 50..<80:
            return (.gray, "Silver Medal")
        default:
            return (.brown, "Bronze Medal")
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Image("leaderboard-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .opacity(0.4)
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                
                ScrollView {
                    GeometryReader { geometry in
                        VStack(spacing: 20) {
                            // MARK: - Medal at the top
                            Image(systemName: "medal.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(medalDetails.color)
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                .padding(.top, 20)
                            
                            Text("You earned a \(medalDetails.text) !")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.primary)
                                .padding(.bottom, 10)
                            
                            // MARK: - Results
                            VStack(spacing: 10) {
                                
                                Image(systemName: "medal.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(medalDetails.color)
                                    .frame(width: 100, height: 100)
                                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                    .padding(.top, 20)
                                
                                Text("You answered 12 out of 30 questions correctly.")
                                    .bold()
                                    .foregroundStyle(.primary)
                                
                                Text("Your time remaining was 14:21:22")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                
                                Text("Your score was 80%")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                
                                // MARK: - View Questions Link
                                Button {
                                    showQuestionsList = true
                                } label: {
                                    Text("View completed questions")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                        .underline()
                                        .padding(.bottom, 40)
                                }
                                .navigationDestination(isPresented: $showQuestionsList) {
                                    AnsweredQuestionsListView(questions: ["Question 1", "Question 2", "Question 3"])
                                        .navigationBarBackButtonHidden(true)
                                }// navigationDestination
                                
                                // MARK: - Try Again Button
                                NavigationLink(destination: StartTestView()
                                    .navigationBarBackButtonHidden(true)
                                ) {
                                    Circle()
                                        .foregroundStyle(.accent)
                                        .frame(height: 150)
                                        .overlay(
                                            Text("Try Again")
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
                                }// NavigationLink
                            }// VStack
                            .padding()
                        }// VStack
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding()
                    }// GeometryReader
                    .navigationTitle("Results")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }// ScrollView
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    ResultTestView()
}
