//
//  FormRowStaticView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 9/3/25.
//

import SwiftUI

struct FormRowStaticView: View {
    // MARK: - Properties
    var icon: String
    var firstText: LocalizedStringResource
    var secondText: LocalizedStringResource
    var rectangleFillColor: Color? = Color.gray
    
    // MARK: - Body
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(rectangleFillColor!)
                Image(systemName: icon)
                    .imageScale(.large)
                    .foregroundStyle(.white)
                    
            }// ZStack
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(firstText).foregroundStyle(.gray)
            Spacer()
            Text(secondText)
        }// HStack
    }// Body
}// View

#Preview {
    FormRowStaticView(icon: "gear", firstText: "Application", secondText: "SecondText")
}
