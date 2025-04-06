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
    // MARK: - Codable Implementation
    // Codable is implemented for potential export/import of ProgressResult data
    // MARK: Coding Keys
    // Defines the keys for decoding/encoding ProgressResult from/to JSON
    enum CodingKeys: String, CodingKey {
        case id, date, totalQuestions, correctAnswers, duration, questionResults
    }
    
    // MARK: Decoding
    // Initializes a ProgressResult object from JSON data
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("Failed to decode ProgressResult: Missing managed object context")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        // Temporary debug: Check if idString is a valid UUID
        if UUID(uuidString: idString) == nil {
            print("⚠️ Invalid UUID string in JSON for ProgressResult: \(idString). Generating new UUID.")
        } // delete this code in final commit
        self.id = UUID(uuidString: idString) ?? UUID()
        
        self.date = try container.decodeIfPresent(Date.self, forKey: .date)
        self.totalQuestions = try container.decode(Int32.self, forKey: .totalQuestions)
        self.correctAnswers = try container.decode(Int32.self, forKey: .correctAnswers)
        self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
        
        if let questionResultsArray = try container.decodeIfPresent([QuestionResult].self, forKey: .questionResults), !questionResultsArray.isEmpty {
            self.questionResults = NSSet(array: questionResultsArray)
        } else {
            self.questionResults = NSSet()
        }
    }
    
    // MARK: Encoding
    // Encodes the ProgressResult object into JSON data
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encode(totalQuestions, forKey: .totalQuestions)
        try container.encode(correctAnswers, forKey: .correctAnswers)
        try container.encodeIfPresent(duration, forKey: .duration)
        try container.encode(questionResults?.allObjects as? [QuestionResult] ?? [], forKey: .questionResults)
    }
}
