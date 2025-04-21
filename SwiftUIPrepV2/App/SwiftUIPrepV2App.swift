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
    @StateObject private var languageManager: LanguageManager
    
    private var coreDataRepository: CoreDataRepositoryProtocol {
        CoreDataRepository(viewContext: persistenceController.container.viewContext)
    }
    
    @StateObject private var testViewModel = TestViewModel(coreDataRepository: CoreDataRepository(viewContext: PersistenceController.shared.container.viewContext))
    
    // MARK: - Initialization
    init() {
        ValueTransformer.setValueTransformer(StringArrayTransformer(), forName: NSValueTransformerName(rawValue: "StringArrayTransformer"))
        let context = PersistenceController.shared.container.viewContext
        self._languageManager = StateObject(wrappedValue: LanguageManager(viewContext: context))
    }
    
    // MARK: - Scene
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(testViewModel)
                .environmentObject(themeManager)
                .environmentObject(languageManager)
                .environment(\.locale, languageManager.locale)
                .preferredColorScheme(themeManager.themeMode.colorScheme)
                .onAppear {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        themeManager.applyTheme(to: windowScene)
                    }
                }
        } // WindowGroup
    } // body
} // App
