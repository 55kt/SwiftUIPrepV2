//
//  Category+CoreDataClass.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 21/3/25.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject, Identifiable, Codable {
    // Реализация Codable
    enum CodingKeys: String, CodingKey {
        case id, name, iconName, questions
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("Failed to decode Category: Missing managed object context")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString) ?? UUID()
        
        self.name = try container.decode(String.self, forKey: .name)
        self.iconName = try container.decode(String.self, forKey: .iconName)
        
        if let questionsArray = try container.decodeIfPresent([Question].self, forKey: .questions) {
            self.questions = NSSet(array: questionsArray)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(iconName, forKey: .iconName)
        try container.encode(questions?.allObjects as? [Question], forKey: .questions)
    }
}
