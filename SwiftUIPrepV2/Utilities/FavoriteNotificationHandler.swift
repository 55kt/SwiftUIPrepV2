//
//  FavoriteNotificationHandler.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 12/4/25.
//

import SwiftUI
import CoreData

class FavoriteNotificationHandler: ObservableObject {
    // MARK: - Published Properties
    @Published var showBanner: Bool = false
    @Published var bannerMessage: String = ""
    @Published var bannerColor: Color = .green
    @Published var isBannerActive: Bool = false
    
    func toggleFavorite(_ question: Question, in context: NSManagedObjectContext, allowRemoval: Bool = true) {
        guard !isBannerActive else { return }
        
        if !question.isFavorite {
            question.isFavorite = true
            do {
                try context.save()
                bannerMessage = "Question added to favorites!"
                bannerColor = .green
                showBanner = true
                isBannerActive = true
            } catch {
                print("❌ Error saving isFavorite: \(error)") // delete this code in final commit
            }
        } else if allowRemoval {
            question.isFavorite = false
            do {
                try context.save()
                bannerMessage = "Question removed from favorites!"
                bannerColor = .red
                showBanner = true
                isBannerActive = true
            } catch {
                print("❌ Error saving isFavorite: \(error)") // delete this code in final commit
            }
        } else {
            bannerMessage = "Question is already in favorites!"
            bannerColor = .yellow
            showBanner = true
            isBannerActive = true
        }
    }
}
