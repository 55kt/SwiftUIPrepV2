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
    let persistenceController = PersistenceController.shared
    @AppStorage("AppTheme") private var isDarkMode: Bool = false
    
    init() {
            ValueTransformer.setValueTransformer(StringArrayTransformer(), forName: NSValueTransformerName(rawValue: "StringArrayTransformer"))
            
            LocalizationHelper.shared.loadCategoriesAndQuestions(into: persistenceController.container.viewContext)
        }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : nil)
        }
    }
}
