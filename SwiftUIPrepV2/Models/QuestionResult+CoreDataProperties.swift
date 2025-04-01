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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionResult> {
        return NSFetchRequest<QuestionResult>(entityName: "QuestionResult")
    }

    @NSManaged public var questionText: String?
    @NSManaged public var isAnsweredCorrectly: Bool

}

extension QuestionResult : Identifiable {

}
