//
//  FavoriteNotificationHandler.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 12/4/25.
//

import SwiftUI
import CoreData

// MARK: - Banner Type Enum
enum BannerType {
    case added
    case removed
    case alreadyExists
    
    var message: String {
        switch self {
        case .added:
            return "Question added to favorites!"
        case .removed:
            return "Question removed from favorites!"
        case .alreadyExists:
            return "Question is already in favorites!"
        }
    }
    
    var color: Color {
        switch self {
        case .added:
            return .green
        case .removed:
            return .red
        case .alreadyExists:
            return .yellow
        }
    }
    
    var icon: String {
        switch self {
        case .added:
            return "star.fill"
        case .removed:
            return "trash.fill"
        case .alreadyExists:
            return "folder.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .added:
            return .yellow
        case .removed:
            return .gray
        case .alreadyExists:
            return Color(red: 0.82, green: 0.71, blue: 0.45)
        }
    }
    
    var effectName: String {
        switch self {
        case .added:
            return "bounce"
        case .removed:
            return "pulse"
        case .alreadyExists:
            return "scale"
        }
    }
}

class FavoriteNotificationHandler: ObservableObject {
    // MARK: - Published Properties
    @Published var showBanner: Bool = false
    @Published var bannerType: BannerType? = nil
    @Published var isBannerActive: Bool = false
    
    func toggleFavorite(_ question: Question, in context: NSManagedObjectContext, allowRemoval: Bool = true) {
        guard !isBannerActive else { return }
        
        if !question.isFavorite {
            question.isFavorite = true
            do {
                try context.save()
                bannerType = .added
                showBanner = true
                isBannerActive = true
            } catch {
                print("❌ Error saving isFavorite: \(error)") // delete this code in final commit
            }
        } else if allowRemoval {
            question.isFavorite = false
            do {
                try context.save()
                bannerType = .removed
                showBanner = true
                isBannerActive = true
            } catch {
                print("❌ Error saving isFavorite: \(error)") // delete this code in final commit
            }
        } else {
            bannerType = .alreadyExists
            showBanner = true
            isBannerActive = true
        }
    }
}
