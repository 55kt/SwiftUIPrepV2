//
//  LanguageManager.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 21/4/25.
//

import Foundation
import SwiftUI
import CoreData

class LanguageManager: ObservableObject {
    // MARK: - Properties
    @Published var currentLanguage: String {
        didSet {
            updateLanguageInCoreData()
            updateAppLocale()
        }
    }
    private let viewContext: NSManagedObjectContext
    
    // MARK: - Initialization
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.currentLanguage = "en"
        defer {
            self.currentLanguage = fetchLanguage() ?? defaultLanguage()
        }
    }
    
    // MARK: - Methods
    func setLanguage(_ language: String) {
        currentLanguage = language
    }
    
    var locale: Locale {
        return Locale(identifier: currentLanguage)
    }
    
    // MARK: - Core Data Methods
    private func fetchLanguage() -> String? {
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        do {
            let settings = try viewContext.fetch(fetchRequest)
            if let appSettings = settings.first {
                return appSettings.language
            } else {
                let newSettings = AppSettings(context: viewContext)
                newSettings.language = defaultLanguage()
                try viewContext.save()
                return newSettings.language
            }
        } catch {
            print("❌ Error fetching language: \(error)")
            return nil
        }
    }
    
    private func updateLanguageInCoreData() {
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        do {
            let settings = try viewContext.fetch(fetchRequest)
            if let appSettings = settings.first {
                appSettings.language = currentLanguage
            } else {
                let newSettings = AppSettings(context: viewContext)
                newSettings.language = currentLanguage
            }
            try viewContext.save()
        } catch {
            print("❌ Error updating language: \(error)")
        }
    }
    
    // MARK: - Default Language
    private func defaultLanguage() -> String {
        let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        let supportedLanguages = AppLanguage.allCases.map { $0.rawValue }
        return supportedLanguages.contains(deviceLanguage) ? deviceLanguage : "en"
    }
    
    // MARK: - Locale Update
    private func updateAppLocale() {
        // Обновляем локаль приложения через Bundle
        Bundle.main.updateLocale(to: currentLanguage)
    }
}

// MARK: - Bundle Locale Extension
extension Bundle {
    func updateLocale(to language: String) {
        UserDefaults.standard.set(language, forKey: "AppLanguage")
        UserDefaults.standard.synchronize()
    }
}
