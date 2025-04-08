//
//  Persistence.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import CoreData

struct PersistenceController {
    // MARK: - Properties
    static let shared = PersistenceController() // Singleton instance for the app
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        result.loadCategoriesAndQuestions(into: viewContext)
        do {
            try viewContext.save()
        } catch {
            print("❌ Error saving preview context: \(error)") // delete this code in final commit
        }
        return result
    }() // Preview instance for SwiftUI previews
    
    let container: NSPersistentContainer // Core Data persistent container
    
    // MARK: - Initialization
    // Initializes the persistence controller, optionally in-memory for previews
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftUIPrepV2")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Load persistent stores
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("❌ Error loading persistent stores: \(error), \(error.userInfo)") // delete this code in final commit
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Check and load categories if needed
        let viewContext = container.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            let categories = try viewContext.fetch(fetchRequest)
            if categories.isEmpty {
                clearCategoriesAndQuestions(from: viewContext)
                loadCategoriesAndQuestions(into: viewContext)
            }
            
            // Debug: Check iconName for all questions
            let allQuestionsFetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
            let allQuestions = try viewContext.fetch(allQuestionsFetchRequest)
            for question in allQuestions {
                print("🔍 Question: \(question.question), iconName: \(question.iconName ?? "nil")") // delete this code in final commit
            }
        } catch {
            print("❌ Error checking categories: \(error)") // delete this code in final commit
        }
    } // init
    
    // MARK: - Private Methods
    // Clears all categories, questions, and question results from the context
    private func clearCategoriesAndQuestions(from context: NSManagedObjectContext) {
        let entities = ["Category", "Question", "QuestionResult"]
        // Delete all entities of each type
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
            } catch {
                print("❌ Error clearing \(entity) entities: \(error)") // delete this code in final commit
            }
        }
        
        // Save the context after clearing
        do {
            try context.save()
        } catch {
            print("❌ Error saving context after clearing data: \(error)") // delete this code in final commit
        }
    }
    
    // Loads categories and questions from a JSON file into the context
    func loadCategoriesAndQuestions(into context: NSManagedObjectContext) {
        // Determine the JSON file based on the user's language
        let languageCode = Locale.preferredLanguages.first ?? "en-US"
        let jsonFileName = languageCode.hasPrefix("ru") ? "questions_ru" : "questions_en"
        
        // Load the JSON file
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
            print("❌ Failed to locate \(jsonFileName).json in bundle") // delete this code in final commit
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.userInfo[.managedObjectContext] = context
            _ = try decoder.decode(CategoriesContainer.self, from: data)
            try context.save()
        } catch {
            print("❌ Error loading JSON data: \(error)") // delete this code in final commit
        }
    }
}

// MARK: - Helper Struct for Decoding JSON
struct CategoriesContainer: Codable {
    let categories: [Category] // Array of categories decoded from JSON
} // CategoriesContainer
