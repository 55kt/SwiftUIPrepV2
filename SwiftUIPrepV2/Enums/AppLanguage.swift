//
//  AppLanguage.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 21/4/25.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case russian = "ru"
    
    // MARK: - Identifiable
    var id: String { rawValue }
    
    var englishName: String {
        switch self {
        case .english:
            return "English"
        case .russian:
            return "Russian"
        }
    }
    
    var nativeName: String {
        switch self {
        case .english:
            return "English"
        case .russian:
            return "Русский"
        }
    }
}
