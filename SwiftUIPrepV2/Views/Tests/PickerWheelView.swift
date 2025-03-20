//
//  PickerWheelView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 19/3/25.
//

import SwiftUI

struct PickerWheelView: View {
    // MARK: - Properties
    @Binding var numberOfQuestions: Int
    let questionOptions = Array(1...150)
    
    var body: some View {
        ZStack {
            Image("test-icon")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .opacity(0.4)
                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
            
            Picker("Number of questions", selection: $numberOfQuestions) {
                ForEach(questionOptions, id: \.self) { num in
                    Text("\(num)")
                        .tag(num)
                        .font(.title)
                }// ForEach
            }// Picker
            .frame(width: 350, height: 350)
            .pickerStyle(.inline)
        }// ZStack
    }// Body
}// View

#Preview {
    PickerWheelView(numberOfQuestions: .constant(5))
}
