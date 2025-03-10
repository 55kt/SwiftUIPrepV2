//
//  LanguageSelectionView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct LanguageSelectionView: View {
    // MARK: - Properties
    @State private var isLoading: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        ZStack {
            List {
                Section(header: Text(LocalizedStringKey("INTERFACE LANGUAGE"))) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("English")
                            .font(.headline)
                        Text("English")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }// VStack
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }// HStack
                            .padding(.trailing, 8)
                    )// background
                    .contentShape(Rectangle())
                }// Section
            }// List
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .bold()
                    }
                }// ToolbarItem
            }// .toolbar
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .disabled(isLoading)
        }// ZStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    LanguageSelectionView()
}
