//
//  ProgressResult+CoreDataClass.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 30/3/25.
//
//

import Foundation
import CoreData

@objc(ProgressResult)
public class ProgressResult: NSManagedObject, Identifiable, Codable {
    // Реализация Codable
    enum CodingKeys: String, CodingKey {
        case id, date, totalQuestions, correctAnswers, duration, questionResults
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("Failed to decode ProgressResult: Missing managed object context")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString) ?? UUID()
        
        self.date = try container.decodeIfPresent(Date.self, forKey: .date)
        self.totalQuestions = try container.decode(Int32.self, forKey: .totalQuestions)
        self.correctAnswers = try container.decode(Int32.self, forKey: .correctAnswers)
        self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
        
        if let questionResultsArray = try container.decodeIfPresent([QuestionResult].self, forKey: .questionResults) {
            self.questionResults = NSSet(array: questionResultsArray)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encode(totalQuestions, forKey: .totalQuestions)
        try container.encode(correctAnswers, forKey: .correctAnswers)
        try container.encodeIfPresent(duration, forKey: .duration)
        try container.encode(questionResults?.allObjects as? [QuestionResult], forKey: .questionResults)
    }
}
