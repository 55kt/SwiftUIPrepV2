//
//  TestSettingsView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct TestSettingsView: View {
    // MARK: - Properties
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // MARK: - Header
                Text("Test Settings")
                    .font(.largeTitle)
                    .bold()
                    .padding()
            }// VStack
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    TestSettingsView()
}
