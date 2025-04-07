//
//  ResultTestView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

struct ResultTestView: View {
    // MARK: - Properties
    let totalQuestions: Int
    let correctAnswers: Int
    let testDuration: String
    let progressResult: ProgressResult?
    
    @EnvironmentObject private var testViewModel: TestViewModel
    @State private var isButtonPulsating = false
    @State private var showQuestionsList = false
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Initialization
    init(totalQuestions: Int, correctAnswers: Int, testDuration: String, progressResult: ProgressResult?) {
        self.totalQuestions = totalQuestions
        self.correctAnswers = correctAnswers
        self.testDuration = testDuration
        self.progressResult = progressResult
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
                                .foregroundStyle(testViewModel.medalDetails.color)
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                .padding(.top, 20)
                            
                            Text("You earned a \(testViewModel.medalDetails.text)!")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.primary)
                                .padding(.bottom, 10)
                            
                            // MARK: - Results
                            VStack(spacing: 10) {
                                Image(systemName: "medal.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(testViewModel.medalDetails.color)
                                    .frame(width: 100, height: 100)
                                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                    .padding(.top, 20)
                                
                                Text("You answered \(correctAnswers) out of \(totalQuestions) questions correctly.")
                                    .bold()
                                    .foregroundStyle(.primary)
                                
                                Text("Your time remaining was \(testDuration)")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                
                                Text("Your score was \(String(format: "%.1f", testViewModel.scorePercentage))%")
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
                                } // Button
                                .navigationDestination(isPresented: $showQuestionsList) {
                                    AnsweredQuestionsListView(progressResult: progressResult)
                                        .navigationBarBackButtonHidden(true)
                                } // navigationDestination
                                
                                // MARK: - Try Again Button
                                NavigationLink {
                                    StartTestView()
                                        .navigationBarBackButtonHidden(true)
                                        .environmentObject(testViewModel)
                                } label: {
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
                                        } // onAppear
                                } // NavigationLink
                            } // VStack
                            .padding()
                        } // VStack
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding()
                    } // GeometryReader
                    .navigationTitle("Results")
                    .navigationBarTitleDisplayMode(.inline)
                } // ScrollView
            } // ZStack
        } // NavigationStack
    } // body
} // View

// MARK: - Preview
#Preview {
    ResultTestView(totalQuestions: 10, correctAnswers: 8, testDuration: "00:45", progressResult: nil)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(TestViewModel())
} // Preview

