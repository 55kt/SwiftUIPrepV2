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
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var iconName: String
    @NSManaged public var priority: String
    @NSManaged public var questions: NSSet?
}

// MARK: Generated accessors for questions
extension Category {
    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: Question)
    
    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: Question)
    
    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)
    
    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)
}
