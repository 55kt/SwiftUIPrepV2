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
    @EnvironmentObject private var progressViewModel: ProgressViewModel
    @State private var isButtonPulsating = false
    @State private var showQuestionsList = false
    @Environment(\.dismiss) var dismiss
    
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
                                .foregroundStyle(progressViewModel.medalDetails.color)
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                .padding(.top, 20)
                            
                            Text("You earned a \(progressViewModel.medalDetails.text)!")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.primary)
                                .padding(.bottom, 10)
                            
                            // MARK: - Results
                            VStack(spacing: 10) {
                                Image(systemName: "medal.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(progressViewModel.medalDetails.color)
                                    .frame(width: 100, height: 100)
                                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                    .padding(.top, 20)
                                
                                Text("You answered \(progressViewModel.correctAnswers) out of \(progressViewModel.progressResult?.totalQuestions ?? 0) questions correctly.")
                                    .bold()
                                    .foregroundStyle(.primary)
                                
                                Text("Your time remaining was \(progressViewModel.progressResult?.duration ?? "00:00")")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                
                                Text("Your score was \(String(format: "%.1f", progressViewModel.scorePercentage))%")
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
                                    AnsweredQuestionsListView(progressResult: progressViewModel.progressResult)
                                        .navigationBarBackButtonHidden(true)
                                } // navigationDestination
                                
                                // MARK: - Try Again Button
                                NavigationLink {
                                    StartTestView()
                                        .navigationBarBackButtonHidden(true)
                                        .environmentObject(progressViewModel)
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
    ResultTestView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ProgressViewModel())
} // Preview

