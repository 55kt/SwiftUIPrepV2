//
//  SwiftUIPrepV2App.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

@main
struct SwiftUIPrepV2App: App {
    // MARK: - Properties
    let persistenceController = PersistenceController.shared
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var testViewModel = TestViewModel()
    
    // MARK: - Initialization
    init() {
        // Register ValueTransformer for converting String arrays in Core Data (e.g., for incorrectAnswers in Question)
        ValueTransformer.setValueTransformer(StringArrayTransformer(), forName: NSValueTransformerName(rawValue: "StringArrayTransformer"))
    }// Initializer
    
    // MARK: - Scene
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(testViewModel)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.themeMode.colorScheme)
                .onAppear {
                    // Apply the theme to the window scene on app launch
                    themeManager.applyTheme(to: UIApplication.shared.connectedScenes.first as? UIWindowScene)
                } // onAppear
        }// WindowGroup
    }// Body
}// App
