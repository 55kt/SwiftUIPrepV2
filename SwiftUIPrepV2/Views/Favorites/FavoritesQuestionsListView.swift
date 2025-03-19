//
//  FavoritesQuestionsListView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 18/3/25.
//

import SwiftUI

struct FavoritesQuestionsListView: View {
    // MARK: - Properties
    let questions: [String]
    @Environment(\.dismiss) var dismiss
    @State private var isShowingStopAlert: Bool = false
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    // MARK: - Body
    var body: some View {
        List {
            HStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.yellow)
                
                NavigationLink(destination: QuestionDetailView()) {
                    QuestionListItemView(iconName: "loading-icon")
                }// NavigationLink
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        //action
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                }
            }// HStack
            .listRowBackground(Color.clear)
            
            HStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.yellow)
                
                NavigationLink(destination: QuestionDetailView()) {
                    QuestionListItemView(iconName: "swift-icon")
                }// NavigationLink
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        //action
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                }// swipe
            }// HStack
            .listRowBackground(Color.clear)
        }// List
        .listStyle(.plain)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Favorites")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    isShowingStopAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.title2)
                        .bold()
                }
            }
        }// toolbar
        .alert("Delete all favorites ?", isPresented: $isShowingStopAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                // action
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete all favorites questions ? All questions will be lost. !")
        }// alert
        .enableNavigationGesture()
    }// Body
}// View

#Preview {
    NavigationStack {
        FavoritesQuestionsListView(questions: ["1", "2", "3"])
    }
}
