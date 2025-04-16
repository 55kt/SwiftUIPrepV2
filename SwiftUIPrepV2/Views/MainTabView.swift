//
//  MainTabView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

struct MainTabView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @State private var needsRefresh: Bool = false
    
    // MARK: - Body
    var body: some View {
        let coreDataRepository = CoreDataRepository(viewContext: viewContext)
        let testViewModel = TestViewModel(coreDataRepository: coreDataRepository)
        
        TabView {
            Tab("Explore", systemImage: "house.fill") {
                ExploreView()
            } // Home
            
            Tab("Tests", systemImage: "pencil.circle.fill") {
                StartTestView()
            } // Tests
            
            Tab("Favorites", systemImage: "star.fill") {
                FavoritesView()
            } // Favorites
            
            Tab("Progress", systemImage: "chart.bar.fill") {
                ProgressTabView()
            } // Progress
            
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            } // Settings
        } // TabView
        .environmentObject(testViewModel)
        .onReceive(NotificationCenter.default.publisher(for: NSManagedObjectContext.didChangeObjectsNotification)) { _ in
            needsRefresh.toggle()
        }// onReceive
    } // Body
}

// MARK: - Preview
#Preview {
    let context = PersistenceController.preview.container.viewContext
    let coreDataRepository = CoreDataRepository(viewContext: context)
    let testViewModel = TestViewModel(coreDataRepository: coreDataRepository)
    return MainTabView()
        .environment(\.managedObjectContext, context)
        .environmentObject(testViewModel)
}
