//
//  HomeView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @State private var searchText = ""
    @State private var isShowingCategories = false
    @State private var shuffleTrigger = false
    @State private var isAnimating = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Group {
                if isShowingCategories {
                    CategoryGridView()
                        .navigationTitle("Categories")
                } else {
                    List {
                        ForEach(0...10, id: \.self) { question in
                            NavigationLink(destination: QuestionDetailView()) {
                                QuestionListItemView(iconName: "loading-icon")
                            }// NavigationLink
                        }// ForEach
                    }// List
                    .listStyle(.plain)
                    .navigationTitle("Home")
                }// if - else
            }
            
            // MARK: - Toolbar Buttons
            .toolbar {
                Group {
                    
                    // MARK: Question list button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            let haptics = UIImpactFeedbackGenerator(style: .medium)
                            haptics.impactOccurred()
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isShowingCategories = false
                                isAnimating = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isAnimating = false
                                }
                            }
                        } label: {
                            Image(systemName: "square.fill.text.grid.1x2")
                                .font(.title2)
                                .foregroundStyle(isShowingCategories ? .accent.opacity(0.4) : .accent)
                                .scaleEffect(isAnimating && !isShowingCategories ? 1.1 : 1.0)
                        }
                    }// question list button
                    
                    // MARK: Categories grid button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            let haptics = UIImpactFeedbackGenerator(style: .medium)
                            haptics.impactOccurred()
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isShowingCategories = true
                                isAnimating = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isAnimating = false
                                }
                            }
                        } label: {
                            Image(systemName: "square.stack.fill")
                                .font(.title2)
                                .foregroundStyle(isShowingCategories ? .accent : .accent.opacity(0.4))
                                .scaleEffect(isAnimating && isShowingCategories ? 1.1 : 1.0)
                        }
                    }
                }// categories grid buttons
                
                // MARK: Shuffle button
                if !isShowingCategories {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            let haptics = UIImpactFeedbackGenerator(style: .medium)
                            haptics.impactOccurred()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                shuffleTrigger.toggle()
                                isAnimating = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isAnimating = false
                                }
                            }
                        } label: {
                            Image(systemName: "shuffle")
                                .font(.title2)
                                .rotationEffect(shuffleTrigger ? .degrees(360) : .degrees(0))
                        }
                    }// shuffle button
                }// hiding shuffle button
            }// toolbar
        }// NavigationStack
        .if(!isShowingCategories) { view in
            view.searchable(text: $searchText)
        }// .if
    }// Body
}// View

// MARK: - Preview
#Preview {
    HomeView()
}

// Extension for search
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
