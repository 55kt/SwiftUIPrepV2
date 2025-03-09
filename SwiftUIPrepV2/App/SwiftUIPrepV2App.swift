//
//  SwiftUIPrepV2App.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

@main
struct SwiftUIPrepV2App: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("AppTheme") private var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : nil)
        }
    }
}
