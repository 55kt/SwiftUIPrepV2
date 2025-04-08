//
//  TimeRemainingHolder.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 14/3/25.
//

import SwiftUI

struct TimeRemainingHolder: View {
    // MARK: - Properties
    var timeDuration: String
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 80)
                .clipShape(Capsule())
                .shadow(radius: 4)
            
            HStack {
                Text("Time remaining:")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Image(systemName: "clock")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(timeDuration)
                    .font(.headline)
            }// HStack
            .padding()
        }// ZStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    TimeRemainingHolder(timeDuration: "12:55:09")
}
