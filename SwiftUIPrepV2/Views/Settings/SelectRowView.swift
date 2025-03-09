//
//  SelectRowView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 9/3/25.
//

import SwiftUI

struct SelectRowView: View {
    // MARK: - Properties
    var color: Color
    var icon: String
    var text: LocalizedStringKey
    var action: () -> Void
    
    // MARK: - Body
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                Image(systemName: icon)
                    .imageScale(.large)
                    .foregroundStyle(.white)
            }// ZStack
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(text)
                .foregroundStyle(.gray)
            
            Spacer()
        }// HStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    SelectRowView(color: .accent, icon: "globe", text: "Button Text Name") {}
}
