//
//  LanguageSelectionView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct LanguageSelectionView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var languageManager: LanguageManager
    @State private var isLoading: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            List {
                Section(header: Text(LocalizedStringKey("INTERFACE LANGUAGE"))) {
                    ForEach(AppLanguage.allCases) { language in
                        Button(action: {
                            guard languageManager.currentLanguage != language.rawValue else { return }
                            isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                languageManager.setLanguage(language.rawValue)
                                isLoading = false
                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(language.englishName)
                                        .font(.headline)
                                    Text(language.nativeName)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                } // VStack
                                Spacer()
                                if languageManager.currentLanguage == language.rawValue {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            } // HStack
                            .padding(.vertical, 6)
                            .opacity(isLoading && languageManager.currentLanguage != language.rawValue ? 0.7 : 1.0)
                        } // Button
                        .buttonStyle(.plain)
                        .disabled(isLoading && languageManager.currentLanguage != language.rawValue)
                    } // ForEach
                } // Section
            } // List
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
                } // ToolbarItem
            } // toolbar
            .enableNavigationGesture()
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .disabled(isLoading)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .ignoresSafeArea()
            }
        } // ZStack
    } // body
} // View

// MARK: - Preview
#Preview {
    LanguageSelectionView()
        .environmentObject(LanguageManager(viewContext: PersistenceController.preview.container.viewContext))
}
