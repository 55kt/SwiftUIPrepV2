//
//  ProgressItemView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 10/3/25.
//

import SwiftUI

struct ProgressItemView: View {
    // MARK: - Properties
    let answeredQText: String
    let time: LocalizedStringKey
    let date: Date
    let medalColor: Color
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            Image(systemName: "medal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .foregroundStyle(medalColor)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(answeredQText)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.accent)
                
                Text(time)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Text(date.formatted(date: .numeric, time: .shortened))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }// VStack
        }// HStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    ProgressItemView(answeredQText: "You answered 10 out of 10 questions",
                     time: "Your time is 12:32",
                     date: Date(),
                     medalColor: .yellow
    )
}
