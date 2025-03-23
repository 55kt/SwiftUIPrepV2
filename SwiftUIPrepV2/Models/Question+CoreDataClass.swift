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
    // Реализация Codable
    enum CodingKeys: String, CodingKey {
        case id, categoryName, question, correctAnswer, incorrectAnswers, iconName, questionDescription, isFavorite, isAnswered, isAnsweredCorrectly, category
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("Failed to decode Question: Missing managed object context")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString) ?? UUID()
        
        self.categoryName = try container.decode(String.self, forKey: .categoryName)
        self.question = try container.decode(String.self, forKey: .question)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        self.incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
        self.questionDescription = try container.decode(String.self, forKey: .questionDescription)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.isAnswered = try container.decode(Bool.self, forKey: .isAnswered)
        self.isAnsweredCorrectly = try container.decodeIfPresent(Bool.self, forKey: .isAnsweredCorrectly)
        self.category = try container.decodeIfPresent(Category.self, forKey: .category)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(categoryName, forKey: .categoryName)
        try container.encode(question, forKey: .question)
        try container.encode(correctAnswer, forKey: .correctAnswer)
        try container.encode(incorrectAnswers, forKey: .incorrectAnswers)
        // Используем iconName из category
        try container.encode(category?.iconName, forKey: .iconName)
        try container.encode(questionDescription, forKey: .questionDescription)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(isAnswered, forKey: .isAnswered)
        try container.encodeIfPresent(isAnsweredCorrectly, forKey: .isAnsweredCorrectly)
        try container.encodeIfPresent(category, forKey: .category)
    }
}
