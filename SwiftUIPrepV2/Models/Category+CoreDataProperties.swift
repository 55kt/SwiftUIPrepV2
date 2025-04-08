//
//  Category+CoreDataProperties.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 21/3/25.
//
//

import Foundation
import CoreData

extension Category {
    // MARK: - Fetch Request
    // Creates a fetch request for retrieving Category objects from Core Data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    // MARK: - Properties
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var iconName: String
    @NSManaged public var priority: String?
    @NSManaged public var questions: NSSet?

    // MARK: - Generated Accessors for questions
    // Adds a single question to the category
    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: Question)

    // Removes a single question from the category
    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: Question)

    // Adds multiple questions to the category
    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    // Removes multiple questions from the category
    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)
}
