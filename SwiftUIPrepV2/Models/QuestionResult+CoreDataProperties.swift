//
//  QuestionResult+CoreDataProperties.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 1/4/25.
//
//

import Foundation
import CoreData

extension QuestionResult {
    // MARK: - Fetch Request
    // Creates a fetch request for retrieving QuestionResult objects from Core Data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionResult> {
        return NSFetchRequest<QuestionResult>(entityName: "QuestionResult")
    }

    // MARK: - Properties
    @NSManaged public var isAnsweredCorrectly: Bool
    @NSManaged public var progressResult: ProgressResult?
    @NSManaged public var question: Question?

    // MARK: - Computed Properties
    // Provides a unique identifier for Identifiable protocol using Core Data's objectID
    public var id: NSManagedObjectID {
        return objectID
    }
}
