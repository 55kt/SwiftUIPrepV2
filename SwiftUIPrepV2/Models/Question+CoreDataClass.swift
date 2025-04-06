//
//  Question+CoreDataClass.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 23/3/25.
//
//

import Foundation
import CoreData

@objc(Question)
public class Question: NSManagedObject, Identifiable, Codable {
    // MARK: - Codable Implementation
    // MARK: Coding Keys
    // Defines the keys for decoding/encoding Question from/to JSON
    enum CodingKeys: String, CodingKey {
        case id, question, correctAnswer, incorrectAnswers, questionDescription, isFavorite, isAnswered, isAnsweredCorrectly, category, iconName
    }
    
    // MARK: Decoding
    // Initializes a Question object from JSON data
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("Failed to decode Question: Missing managed object context")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        // Temporary debug: Check if idString is a valid UUID
        if UUID(uuidString: idString) == nil {
            print("⚠️ Invalid UUID string in JSON for Question: \(idString). Generating new UUID. ⚠️")
        } // delete this code in final commit
        self.id = UUID(uuidString: idString) ?? UUID()
        
        self.question = try container.decode(String.self, forKey: .question)
        self.questionDescription = try container.decode(String.self, forKey: .questionDescription)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        // incorrectAnswers is decoded as [String] and transformed using StringArrayTransformer
        self.incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.isAnswered = try container.decode(Bool.self, forKey: .isAnswered)
        self.isAnsweredCorrectly = try container.decodeIfPresent(Bool.self, forKey: .isAnsweredCorrectly)
        // category is not present in JSON (set later by the parent Category)
        self.category = try container.decodeIfPresent(Category.self, forKey: .category)
        self.iconName = try container.decodeIfPresent(String.self, forKey: .iconName)
    }
    
    // MARK: Encoding
    // Encodes the Question object into JSON data
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(question, forKey: .question)
        try container.encode(questionDescription, forKey: .questionDescription)
        try container.encode(correctAnswer, forKey: .correctAnswer)
        try container.encode(incorrectAnswers, forKey: .incorrectAnswers)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(isAnswered, forKey: .isAnswered)
        try container.encodeIfPresent(isAnsweredCorrectly, forKey: .isAnsweredCorrectly)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(iconName, forKey: .iconName)
    }
}
