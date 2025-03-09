//
//  CopyrightSection.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 9/3/25.
//

import SwiftUI

struct CopyrightSection: View {
    private let currentYear: String = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter.string(from: Date())
        }()

        var body: some View {
            Text("Copyright © \(currentYear) Volos Software LLC. All rights reserved")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
}

#Preview {
    CopyrightSection()
}
