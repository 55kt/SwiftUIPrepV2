//
//  ButtonGradients.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 14/3/25.
//

import SwiftUI

struct ButtonGradients {
    static let correctAnswer = LinearGradient(
        gradient: Gradient(colors: [Color.green.opacity(0.8), Color.teal.opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let incorrectAnswer = LinearGradient(
        gradient: Gradient(colors: [Color.red.opacity(0.9), Color.orange.opacity(0.9)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let defaultButton = LinearGradient(
        gradient: Gradient(colors: [Color.gray.opacity(0.25)]),
        startPoint: .top,
        endPoint: .bottom
    )
}
