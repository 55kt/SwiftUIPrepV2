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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressResult> {
        return NSFetchRequest<ProgressResult>(entityName: "ProgressResult")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var totalQuestions: Int32
    @NSManaged public var correctAnswers: Int32
    @NSManaged public var duration: String?
    @NSManaged public var questions: NSSet?

}

// MARK: Generated accessors for questions
extension ProgressResult {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: Question)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: Question)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}

extension ProgressResult : Identifiable {

}
