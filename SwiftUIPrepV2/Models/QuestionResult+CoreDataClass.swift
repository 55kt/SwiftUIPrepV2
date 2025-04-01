//
//  QuestionResult+CoreDataClass.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 1/4/25.
//
//

import Foundation
import CoreData

@objc(QuestionResult)
public class QuestionResult: NSManagedObject, Identifiable, Codable {
    // Реализация Codable
    enum CodingKeys: String, CodingKey {
        case isAnsweredCorrectly, progressResult, question
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("Failed to decode QuestionResult: Missing managed object context")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isAnsweredCorrectly = try container.decode(Bool.self, forKey: .isAnsweredCorrectly)
        self.progressResult = try container.decodeIfPresent(ProgressResult.self, forKey: .progressResult)
        self.question = try container.decodeIfPresent(Question.self, forKey: .question)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isAnsweredCorrectly, forKey: .isAnsweredCorrectly)
        try container.encodeIfPresent(progressResult, forKey: .progressResult)
        try container.encodeIfPresent(question, forKey: .question)
    }
}
