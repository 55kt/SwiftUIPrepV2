//
//  ProgressView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct ProgressView: View {
    // MARK: - Properties
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                ForEach(0 ..< 10) { index in
                    Text("Item \(index)")
                }// ForEach
            }// List
            .navigationTitle("Progress")
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    ProgressView()
}
