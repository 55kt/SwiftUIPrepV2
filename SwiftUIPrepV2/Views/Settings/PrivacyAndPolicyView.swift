//
//  PrivacyAndPolicyView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 9/3/25.
//

import SwiftUI

struct PrivacyAndPolicyView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy & Policy")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Header")
                        .font(.headline)
                        .foregroundStyle(.accent)
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam id blandit neque. Praesent porta, metus a feugiat mollis, nulla ligula tincidunt risus, ac pretium dolor est eu dolor. Mauris placerat tortor eget justo lacinia, et dapibus nisl dignissim. Proin eu accumsan ex. Nulla suscipit neque id gravida iaculis. Fusce interdum a nisl eu auctor. Maecenas non tristique velit, id vulputate ante. Vivamus sit amet ipsum neque.")
                        .font(.body)
                        .foregroundColor(.primary)
                }// VStack
            }// VStack
            .padding()
        }// ScrollView
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }// ToolbarItem
        }// toolbar
    }// Body
}// View

// MARK: - Preview
#Preview {
    NavigationStack {
        PrivacyAndPolicyView()
    }
}
