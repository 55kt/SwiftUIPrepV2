//
//  ProgressResult+CoreDataProperties.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 30/3/25.
//
//

import Foundation
import CoreData


import Foundation
import CoreData

extension ProgressResult {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressResult> {
        return NSFetchRequest<ProgressResult>(entityName: "ProgressResult")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date?
    @NSManaged public var totalQuestions: Int32
    @NSManaged public var correctAnswers: Int32
    @NSManaged public var duration: String?
    @NSManaged public var questionResults: NSSet?

    @objc(addQuestionResultsObject:)
    @NSManaged public func addToQuestionResults(_ value: QuestionResult)

    @objc(removeQuestionResultsObject:)
    @NSManaged public func removeFromQuestionResults(_ value: QuestionResult)

    @objc(addQuestionResults:)
    @NSManaged public func addToQuestionResults(_ values: NSSet)

    @objc(removeQuestionResults:)
    @NSManaged public func removeFromQuestionResults(_ values: NSSet)
}
