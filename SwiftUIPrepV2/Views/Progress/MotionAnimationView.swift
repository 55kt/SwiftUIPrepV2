//
//  MotionAnimationView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 10/3/25.
//

import SwiftUI

struct MotionAnimationView: View {
    // MARK: - Properties
    @State private var randomCircle = Int.random(in: 8...12)
    @State private var isAnimating: Bool = false
    
    // MARK: - Functions
    
    // 1. Random coordinate
    func randomCoordinate(max: CGFloat) -> CGFloat {
        return CGFloat.random(in: 0...max)
    }
    
    // 2. Random size
    func randomSize() -> CGFloat {
        return CGFloat.random(in: 20...150)
    }
    
    // 3. Random scale
    func randomScale() -> CGFloat {
        return CGFloat(Double.random(in: 0.1...0.2))
    }
    
    // 4. Random speed
    func randomSpeed() -> Double {
        return Double.random(in: 0.050...1.0)
    }
    
    // 5. Randon delay
    func randomDelay() -> Double {
        return Double.random(in: 0...2)
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0...randomCircle, id: \.self) { item in
                    Circle()
                        .foregroundStyle(.gray)
                        .opacity(0.15)
                        .frame(width: randomSize(), height: randomSize(), alignment: .center)
                        .scaleEffect(isAnimating ? 1 : randomScale())
                        .position(
                            x: randomCoordinate(max: geometry.size.width),
                            y: randomCoordinate(max: geometry.size.height)
                        )
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay()) {
                                withAnimation(
                                    Animation.interpolatingSpring(stiffness: 0.5, damping: 0.5)
                                        .repeatForever()
                                        .speed(randomSpeed())
                                ) {
                                    isAnimating = true
                                }
                            }
                        }// OnAppear
                }// ForEach
            }// ZStack
            .onDisappear {
                isAnimating = false
            }
        }// GeometryReader
    }// Body
}// View

// MARK: - Preview
#Preview {
    MotionAnimationView()
}
