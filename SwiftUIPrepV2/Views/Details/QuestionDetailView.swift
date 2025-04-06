//
//  QuestionDetailView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 4/3/25.
//

import SwiftUI

struct QuestionDetailView: View {
    // MARK: - Properties
    @ObservedObject var question: Question
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isFavorite: Bool
    
    init(question: Question) {
        self.question = question
        self._isFavorite = State(initialValue: question.isFavorite)
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                HStack {
                    Image(question.iconName ?? "unknown-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question.category?.name ?? "Unknown")
                            .font(.title2)
                            .fontWeight(.heavy)
                    }// VStack
                }// HStack
                .padding(.horizontal)
                .padding(.vertical)
                
                VStack(alignment: .center, spacing: 0) {
                    // MARK: - Question
                    Section {
                        HeadingView(headingImage: "questionmark.bubble.fill", headingText: "Question", headingColor: .accent)
                        
                        Text(question.question)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding(.vertical, 8)
                    }// Question section
                    .padding(.horizontal)
                    
                    // MARK: - Answer
                    Section {
                        HeadingView(headingImage: "graduationcap.fill", headingText: "Answer", headingColor: .accent)
                        
                        Text(question.correctAnswer)
                            .font(.headline)
                            .padding(.horizontal)
                    }// Answer section
                    .padding(.horizontal)
                    
                    // MARK: - Description
                    Section {
                        VStack(alignment: .center, spacing: 2) {
                            HeadingView(headingImage: "info.circle.fill", headingText: LocalizedStringKey("Description"), headingColor: .accent)
                            
                            Text(question.questionDescription)
                                .font(.headline)
                                .padding(.horizontal)
                        }// VStack
                    }// Description section
                    .padding(.horizontal)
                }// VStack
            }// VStack
            .padding(.bottom, 50)

            // MARK: - Toolbar buttons
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.accent)
                            .font(.title2)
                            .bold()

                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isFavorite.toggle()
                        question.isFavorite = isFavorite
                        do {
                            try viewContext.save()
                            print("💾 Saved isFavorite: \(isFavorite) for question: \(question.question) 💾")
                        } catch {
                            print("❌ Error saving isFavorite: \(error)")
                        }
                    } label: {
                        Image(systemName: isFavorite ? "star.circle.fill" : "star.circle")
                            .foregroundStyle(isFavorite ? .yellow : .accent)
                            .font(.title2)
                            .bold()
                    }
                }
            }// toolbar
        }// ScrollView
        .navigationBarBackButtonHidden(true)
        .onChange(of: question.isFavorite) { oldValue, newValue in
            isFavorite = newValue
        }// onChange
    }// Body
}// View

// MARK: - Preview
#Preview {
    NavigationStack {
        QuestionDetailView(question: Question(context: PersistenceController.shared.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
