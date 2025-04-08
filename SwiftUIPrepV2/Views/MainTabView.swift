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
    
    // MARK: - Body
    var body: some View {
        TabView {
            Tab("Explore", systemImage: "house.fill") {
                ExploreView()
            }// Home
            
            Tab("Tests", systemImage: "pencil.circle.fill") {
                StartTestView()
            }// Tests
            
            Tab("Favorites", systemImage: "star.fill") {
                FavoritesView()
            }// Favorites
            
            Tab("Progress", systemImage: "chart.bar.fill") {
                ProgressTabView()
            }// Progress
            
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }// Settings
        }// TabView
    }// Body
}// View

// MARK: - Preview
#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)

}
