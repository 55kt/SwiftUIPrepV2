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
    @AppStorage("AppTheme") private var isDarkMode: Bool = false
    @StateObject private var testViewModel = TestViewModel()
    @StateObject private var progressViewModel = ProgressViewModel()
    
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
                .environmentObject(progressViewModel)
                .preferredColorScheme(isDarkMode ? .dark : nil)
        }// WindowGroup
    }// Body
}// App
