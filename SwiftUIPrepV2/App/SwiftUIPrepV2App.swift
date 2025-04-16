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
    
    private var coreDataRepository: CoreDataRepositoryProtocol {
        CoreDataRepository(viewContext: persistenceController.container.viewContext)
    }
    
    @StateObject private var testViewModel = TestViewModel(coreDataRepository: CoreDataRepository(viewContext: PersistenceController.shared.container.viewContext))
    
    // MARK: - Initialization
    init() {
        ValueTransformer.setValueTransformer(StringArrayTransformer(), forName: NSValueTransformerName(rawValue: "StringArrayTransformer"))
    }
    
    // MARK: - Scene
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(testViewModel)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.themeMode.colorScheme)
                // Apply the theme to the window scene on app launch
                .onAppear {
                    // Get the first UIWindowScene from connectedScenes
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        themeManager.applyTheme(to: windowScene)
                    }
                }// onAppear
        } // WindowGroup
    } // body
} // View
