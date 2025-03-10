//
//  SettingsView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Properties
    @State private var isShowingSheet: Bool = false
    @AppStorage("AppTheme") private var isDarkMode: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 6) {
                Form {
                    
                    // MARK: - Language
                    Section(header: Text("Language Selection")) {
                        NavigationLink(destination: LanguageSelectionView()) {
                            SelectRowView( color: .pink, icon: "globe", text: "Language") {}
                        }
                    }// Language select section
                    .padding(2)
                    
                    // MARK: - Appearance
                    Section(header: Text("Appearance")) {
                        Toggle(isOn: $isDarkMode) {
                            HStack {
                                Text("Dark Mode")
                                    .padding(.horizontal, 8)
                                
                                Image(systemName: "moon.fill")
                                    .font(.title)
                                    .foregroundStyle(!isDarkMode ? .gray : .blue)
                                    .animation(.easeInOut(duration: 0.3), value: isDarkMode)
                            }// HStack
                            .padding(5)
                        }// Toggle
                    }// Appearance section
                    
                    // MARK: - About
                    Section(header: Text("About the application")) {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "SwiftUIPrep", rectangleFillColor: .purple)
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone", rectangleFillColor: .green)
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Volos Software LLC", rectangleFillColor: .orange)
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Ivanno Ruddio", rectangleFillColor: .pink)
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0", rectangleFillColor: .blue)
                    }// FormRowStatic Section

                    
                    // MARK: - Footer
                    Section {
                        VStack {
                            Button {
                                isShowingSheet.toggle()
                            } label: {
                                Text("Privacy and Policy")
                                    .foregroundStyle(.blue)
                            }
                            .padding()
                            .sheet(isPresented: $isShowingSheet) {
                                PrivacyAndPolicyView()
                            }// .sheet
                            
                            CopyrightSection()
                                .padding(.top, 6)
                                .padding(.bottom, 8)
                        }// VStack
                        .frame(maxWidth: .infinity, alignment: .center)
                    }// Section
                }// Form
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                
            }// VStack
            .navigationTitle("Settings")
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    SettingsView()
}
