//
//  AppearanceSectionView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 8/4/25.
//

import SwiftUI

struct AppearanceSectionView: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - body
    var body: some View {
        Section(header: Text("Appearance")) {
            HStack(spacing: 0) {
                ForEach(ThemeMode.allCases, id: \.self) { mode in
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            themeManager.themeMode = mode
                            themeManager.applyTheme(to: UIApplication.shared.connectedScenes.first as? UIWindowScene)
                        }
                    } label: {
                        VStack {
                            Image(systemName: mode.iconName)
                                .font(.title2)
                                .foregroundStyle(themeManager.themeMode == mode ? .accent : .gray)
                                .scaleEffect(themeManager.themeMode == mode ? 1.2 : 1.0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: themeManager.themeMode)
                            
                            Text(mode.rawValue)
                                .font(.caption)
                                .foregroundStyle(themeManager.themeMode == mode ? .accent : .gray)
                        } // VStack
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(themeManager.themeMode == mode ? Color.accent.opacity(0.1) : Color.gray.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(themeManager.themeMode == mode ? Color.accent : Color.gray, lineWidth: 1)
                        )
                    } // Button
                    .padding(.horizontal, 10)
                    .buttonStyle(.plain) // Ensure precise button interaction
                } // ForEach
            } // HStack
        } // Section
    } // body
}// View

// MARK: - Preview
#Preview {
    NavigationStack {
        Form {
            AppearanceSectionView()
                .environmentObject(ThemeManager())
        }
    }
}
