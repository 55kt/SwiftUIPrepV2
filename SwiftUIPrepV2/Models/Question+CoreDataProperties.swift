//
//  Question+CoreDataProperties.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 23/3/25.
//
//

import Foundation
import CoreData

extension Question {
    // MARK: - Fetch Request
    // Creates a fetch request for retrieving Question objects from Core Data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    // MARK: - Properties
    @NSManaged public var correctAnswer: String
    @NSManaged public var id: UUID
    @NSManaged public var incorrectAnswers: [String]?
    @NSManaged public var isAnswered: Bool
    @NSManaged public var isAnsweredCorrectlyRaw: NSNumber?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var question: String
    @NSManaged public var questionDescription: String
    @NSManaged public var category: Category?
    @NSManaged public var questionResults: NSSet?
    @NSManaged public var iconName: String?

    // MARK: - Computed Properties
    // Converts isAnsweredCorrectlyRaw (NSNumber?) to Bool? and vice versa
    public var isAnsweredCorrectly: Bool? {
        get { return isAnsweredCorrectlyRaw?.boolValue }
        set { isAnsweredCorrectlyRaw = newValue.map { NSNumber(value: $0) } }
    }

    // MARK: - Generated Accessors for questionResults
    // Adds a single test result to the question
    @objc(addQuestionResultsObject:)
    @NSManaged public func addToQuestionResults(_ value: QuestionResult)

    // Removes a single test result from the question
    @objc(removeQuestionResultsObject:)
    @NSManaged public func removeFromQuestionResults(_ value: QuestionResult)

    // Adds multiple test results to the question
    @objc(addQuestionResults:)
    @NSManaged public func addToQuestionResults(_ values: NSSet)

    // Removes multiple test results from the question
    @objc(removeQuestionResults:)
    @NSManaged public func removeFromQuestionResults(_ values: NSSet)
}
