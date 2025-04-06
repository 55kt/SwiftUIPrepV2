//
//  ProgressResult+CoreDataProperties.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 30/3/25.
//
//

import Foundation
import CoreData

extension ProgressResult {
    // MARK: - Fetch Request
    // Creates a fetch request for retrieving ProgressResult objects from Core Data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressResult> {
        return NSFetchRequest<ProgressResult>(entityName: "ProgressResult")
    }

    // MARK: - Properties
    @NSManaged public var id: UUID
    @NSManaged public var date: Date?
    @NSManaged public var totalQuestions: Int32
    @NSManaged public var correctAnswers: Int32
    @NSManaged public var duration: String?
    @NSManaged public var questionResults: NSSet?

    // MARK: - Generated Accessors for questionResults
    // Adds a single question result to the test
    @objc(addQuestionResultsObject:)
    @NSManaged public func addToQuestionResults(_ value: QuestionResult)

    // Removes a single question result from the test
    @objc(removeQuestionResultsObject:)
    @NSManaged public func removeFromQuestionResults(_ value: QuestionResult)

    // Adds multiple question results to the test
    @objc(addQuestionResults:)
    @NSManaged public func addToQuestionResults(_ values: NSSet)

    // Removes multiple question results from the test
    @objc(removeQuestionResults:)
    @NSManaged public func removeFromQuestionResults(_ values: NSSet)
}
