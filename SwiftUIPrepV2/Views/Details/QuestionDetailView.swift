//
//  QuestionDetailView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 4/3/25.
//

import SwiftUI

struct QuestionDetailView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                HStack {
                    Image("data-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Data")
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
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed venenatis pretium dapibus.?")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding(.vertical, 8)
                    }// Question section
                    .padding(.horizontal)
                    
                    // MARK: - Answer
                    Section {
                        HeadingView(headingImage: "graduationcap.fill", headingText: "Answer", headingColor: .accent)
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed venenatis pretium dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed venenatis pretium dapibus.")
                            .font(.headline)
                            .padding(.horizontal)
                    }// Answer section
                    .padding(.horizontal)
                    
                    // MARK: - Description
                    Section {
                        VStack(alignment: .center, spacing: 2) {
                            HeadingView(headingImage: "info.circle.fill", headingText: LocalizedStringKey("Description"), headingColor: .accent)
                            
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sagittis lacus interdum quam interdum, eget cursus justo luctus. Ut vitae mi malesuada, sollicitudin felis a, dictum odio. Integer dui arcu, accumsan id tellus eget, dictum rhoncus orci. In nec facilisis mauris. Donec egestas, nisi sed finibus elementum, nisi enim volutpat lectus, sed pretium orci nulla quis ex. Duis convallis venenatis tortor, id laoreet ante pellentesque blandit.")
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
//                    .enableNavigationGesture()

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // action
                    } label: {
                        Image(systemName: "star.circle.fill")
                            .foregroundStyle(.accent)
                            .font(.title2)
                    }
                }
            }// toolbar
        }// ScrollView
        .navigationBarBackButtonHidden(true)
    }// Body
}// View

// MARK: - Preview
#Preview {
    NavigationStack {
        QuestionDetailView()
    }
}
