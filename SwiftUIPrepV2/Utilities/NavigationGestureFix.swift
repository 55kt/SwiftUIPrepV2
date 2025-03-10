//
//  NavigationGestureFix.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 10/3/25.
//

import SwiftUI

/// A wrapper to enable the interactive pop gesture for SwiftUI navigation
struct NavigationGestureFix: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            // Enable the interactive pop gesture
            controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            controller.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed for now
    }
}

/// ViewModifier to apply the gesture fix to any SwiftUI View
struct NavigationGestureFixModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(NavigationGestureFix())
    }
}

/// Extension to easily apply the gesture fix
extension View {
    func enableNavigationGesture() -> some View {
        modifier(NavigationGestureFixModifier())
    }
}
