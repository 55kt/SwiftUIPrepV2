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
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

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
    @NSManaged public var categoryIconName: String?

    // MARK: - Computed Properties
    public var isAnsweredCorrectly: Bool? {
        get { return isAnsweredCorrectlyRaw?.boolValue }
        set { isAnsweredCorrectlyRaw = newValue.map { NSNumber(value: $0) } }
    }

    public var iconName: String {
            return categoryIconName ?? category?.iconName ?? "default-icon"
        }

    // MARK: - Generated Accessors for questionResults
    @objc(addQuestionResultsObject:)
    @NSManaged public func addToQuestionResults(_ value: QuestionResult)

    @objc(removeQuestionResultsObject:)
    @NSManaged public func removeFromQuestionResults(_ value: QuestionResult)

    @objc(addQuestionResults:)
    @NSManaged public func addToQuestionResults(_ values: NSSet)

    @objc(removeQuestionResults:)
    @NSManaged public func removeFromQuestionResults(_ values: NSSet)
} // extension
