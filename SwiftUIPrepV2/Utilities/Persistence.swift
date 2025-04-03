//
//  Persistence.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        result.loadCategoriesAndQuestions(into: viewContext)
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftUIPrepV2")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Load questions from JSON only if the database is empty
        let viewContext = container.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            let categories = try viewContext.fetch(fetchRequest)
            if categories.isEmpty {
                print("📀🚀 Starting to load categories and questions into Core Data 🚀📀")
                loadCategoriesAndQuestions(into: viewContext)
            } else {
                print("📂 Categories already exist in Core Data, skipping JSON load")
            }
        } catch {
            print("❌ Error checking categories: \(error)")
        }
    }
    
    // MARK: - Private Methods
    func loadCategoriesAndQuestions(into context: NSManagedObjectContext) {
        // Determine the language for the JSON file
        let languageCode = Locale.preferredLanguages.first ?? "en-US"
        print("🌐 Preferred language: \(languageCode) 🌐")
        let jsonFileName = languageCode.hasPrefix("ru") ? "questions_ru" : "questions_en"
        print("📂 Attempting to load JSON file: \(jsonFileName).json 📂")
        
        // Load JSON data
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
            print("❌ Failed to locate \(jsonFileName).json in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.userInfo[.managedObjectContext] = context
            let categories = try decoder.decode([Category].self, from: data)
            print("✅🥳🎉 Successfully loaded JSON data from \(jsonFileName).json 🥳🎉✅")
            
            try context.save()
            print("👍🏻🎉 Successfully loaded \(categories.count) categories into Core Data 👌🏾")
        } catch {
            print("❌ Error loading JSON data: \(error)")
        }
    }
}
