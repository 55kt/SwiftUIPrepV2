//
//  CategoryGridView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 5/3/25.
//

import SwiftUI

struct CategoryGridView: View {
    // MARK: - Properties
    let gridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    
    @State private var isShowingQuestions = false
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: gridLayout, alignment: .center, spacing: 15) {
                            ForEach(0 ..< 15) { category in
                                NavigationLink(destination: QuestionsListView(questions: ["Question 1"])
                                    .navigationTitle("Data")
                                    .navigationBarTitleDisplayMode(.inline)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar {
                                        ToolbarItem(placement: .navigationBarLeading) {
                                            Button {
                                                dismiss()
                                            } label: {
                                                Image(systemName: "chevron.left")
                                                    .font(.title2)
                                                    .bold()
                                            }
                                        }
                                    }
                                ) {
                                    CategoryGridItemView()
                                }
                            }
                        }
                        .padding()
                    }
        }// NavigationStack
        .foregroundStyle(.primary)
    }// Body
}// View

// MARK: - Properties
#Preview {
    CategoryGridView()
}
