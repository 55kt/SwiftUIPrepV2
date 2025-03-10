//
//  MainTabView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct MainTabView: View {
    // MARK: - Properties
    
    // MARK: - Body
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
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
}
