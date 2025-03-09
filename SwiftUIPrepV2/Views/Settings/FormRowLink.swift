//
//  FormRowLink.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 9/3/25.
//

import SwiftUI

struct FormRowLink: View {
    // MARK: - Properties
    var icon: String
    var color: Color
    var text: LocalizedStringResource
    var link: String
    
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
            
            Text(text).foregroundStyle(.gray)
            
            Spacer()
            
            Button(action: {
                guard let url = URL(string: self.link),
                      UIApplication.shared.canOpenURL(url) else {
                    return
                }
                UIApplication.shared.open(url as URL)
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }// Button
            .foregroundStyle(.gray)
        }// HStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    FormRowLink(icon: "globe", color: Color.pink, text: "Website", link: "https://google.com")
}
