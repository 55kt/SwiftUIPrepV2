////
////  LocalizationHelper.swift
////  SwiftUIPrepV2
////
////  Created by Vlad on 27/2/25.
////
//
//import Foundation
//import CoreData
//
//class LocalizationHelper {
//    static let shared = LocalizationHelper()
//    
//    private init() {}
//    
//    // Getting current language
//    var currentLanguage: String {
//        if let language = Locale.preferredLanguages.first {
//            print("🌐 Preferred language : \(language) 🌐")
//            return String(language.prefix(2))
//        }
//        print("🚫 No preferred language found, defaulting to 🇬🇧'en'🇬🇧")
//        return "en"
//    }// currentLanguage
//    
//    // Load categories and questions from JSON and save to Core Data
//    func loadCategoriesAndQuestions(into context: NSManagedObjectContext) {
//        print("📀🚀 Starting to load categories and questions into Core Data 🚀📀")
//        
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try context.execute(deleteRequest)
//            try context.save()
//            print("🗑️ Successfully cleared existing categories 🧹")
//        } catch {
//            print("‼️🆘 Error clearing Core Data ‼️🆘 : \(error)")
//        }
//        
//        // Loading JSON
//        let fileName = "questions_\(currentLanguage)"
//        print("📂 Attempting to load JSON file: \(fileName).json 📂")
//        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
//            print("🚫 JSON file not found 🤷🏻: \(fileName).json")
//            return
//        }
//        
//        do {
//            let data = try Data(contentsOf: url)
//            print("✅🥳🎉 Successfully loaded JSON data from \(fileName).json 🥳🎉✅")
//            let decoder = JSONDecoder()
//            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
//            let jsonData = try decoder.decode([String: [Category]].self, from: data)
//            let categories = jsonData["categories"] ?? []
//            
//            // Check that all categories have a name and iconName
//            for (index, category) in categories.enumerated() {
//                if category.name.isEmpty {
//                    print("⚠️ Warning: Category at index \(index) has empty name ⚠️")
//                }
//                if category.iconName.isEmpty {
//                    print("⚠️ Warning: Category at index \(index) has empty iconName ⚠️")
//                }
//            }
//            
//            // Save changes to Core Data
//            try context.save()
//            print("👍🏻🎉 Successfully loaded \(categories.count) categories into Core Data 👌🏾")
//        } catch {
//            print("‼️🆘 Error decoding JSON or saving to Core Data ‼️🆘 : \(error)")
//        }// do - catch
//        
//        
//    }// loadCategoriesAndQuestions
//    
//}// class
