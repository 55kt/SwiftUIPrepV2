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
                print("🔍 Question: \(question.question), iconName: \(question.iconName ?? "nil")")
            }
        } catch {
            print("❌ Error checking categories: \(error)")
        }
    }
    
    // MARK: - Private Methods
    private func clearCategoriesAndQuestions(from context: NSManagedObjectContext) {
        let entities = ["Category", "Question", "QuestionResult"]
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
            } catch {
                print("❌ Error clearing \(entity) entities: \(error)")
            }
        }
        do {
            try context.save()
        } catch {
            print("❌ Error saving context after clearing data: \(error)")
        }
    }
    
    func loadCategoriesAndQuestions(into context: NSManagedObjectContext) {
        let languageCode = Locale.preferredLanguages.first ?? "en-US"
        let jsonFileName = languageCode.hasPrefix("ru") ? "questions_ru" : "questions_en"
        
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
            print("❌ Failed to locate \(jsonFileName).json in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.userInfo[.managedObjectContext] = context
            let container = try decoder.decode(CategoriesContainer.self, from: data)
            try context.save()
        } catch {
            print("❌ Error loading JSON data: \(error)")
        }
    }
}

// MARK: - Helper Struct for Decoding JSON
struct CategoriesContainer: Codable {
    let categories: [Category]
}
