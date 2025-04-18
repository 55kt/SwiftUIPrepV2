//
//  BannerView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 12/4/25.
//

import SwiftUI

struct BannerView: View {
    // MARK: - Properties
    @Binding var showBanner: Bool
    @Binding var isBannerActive: Bool
    let bannerType: BannerType?
    
    @State private var offset: CGFloat = -200
    @State private var isVisible: Bool = true
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if isVisible, let bannerType = bannerType {
                HStack(spacing: 10) {
                    let image = Image(systemName: bannerType.icon)
                        .font(.title)
                        .foregroundColor(bannerType.iconColor)
                        .frame(width: 40, height: 40)
                        .padding(5)
                        .background(bannerType.color.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.vertical, 5)
                    
                    Group {
                        if bannerType.effectName == "bounce" {
                            image.symbolEffect(.bounce, options: .repeating)
                        } else if bannerType.effectName == "pulse" {
                            image.symbolEffect(.pulse, options: .repeating)
                        } else if bannerType.effectName == "scale" {
                            image.symbolEffect(.scale, options: .repeating)
                        } else {
                            image
                        }
                    }
                    
                    // Текст
                    Text(bannerType.message)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .padding(.vertical, 10)
                } // HStack
                .frame(maxWidth: .infinity)
                .background(bannerType.color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .padding(.horizontal, 10)
                .offset(y: offset)
            } // if
        } // ZStack
        .frame(height: 80)
        .onChange(of: showBanner) { oldValue, newValue in
            if newValue {
                isVisible = true
                withAnimation(.spring()) {
                    offset = 10
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.spring()) {
                        offset = -200
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isVisible = false
                        showBanner = false
                        isBannerActive = false
                    } // DispatchQueue
                } // DispatchQueue
            } // if
        } // onChange
    } // body
}

// MARK: - Preview
#Preview {
    BannerView(
        showBanner: .constant(true),
        isBannerActive: .constant(true),
        bannerType: .added
    )
}

// bunce
// pulse
// scale
