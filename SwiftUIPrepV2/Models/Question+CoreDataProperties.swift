//
//  Question+CoreDataProperties.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 21/3/25.
//
//

import Foundation
import CoreData

extension Question {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var categoryName: String
    @NSManaged public var question: String
    @NSManaged public var correctAnswer: String
    @NSManaged public var incorrectAnswers: [String]?
    @NSManaged public var iconName: String
    @NSManaged public var questionDescription: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isAnswered: Bool
    @NSManaged public var isAnsweredCorrectlyRaw: NSNumber?
    
    public var isAnsweredCorrectly: Bool? {
        get { return isAnsweredCorrectlyRaw?.boolValue }
        set { isAnsweredCorrectlyRaw = newValue.map { NSNumber(value: $0) } }
    }
    
    @NSManaged public var category: Category?
}
