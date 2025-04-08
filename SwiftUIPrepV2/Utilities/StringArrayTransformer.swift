//
//  StringArrayTransformer.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 21/3/25.
//

import Foundation

// MARK: - Value Transformer for String Arrays
// Transforms an array of strings to Data and back for Core Data storage
@objc(StringArrayTransformer)
class StringArrayTransformer: ValueTransformer {
    // MARK: - Class Methods
    // Specifies the class of the transformed value (NSArray for Core Data)
    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }
    
    // Indicates that reverse transformation is supported
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    // MARK: - Transformation Methods
    // Transforms an array of strings into Data for Core Data storage
    override func transformedValue(_ value: Any?) -> Any? {
        // Ensure the input is an array of strings
        guard let array = value as? [String] else { return nil }
        
        // Archive the array into Data
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: true)
            return data
        } catch {
            print("❌ Error archiving string array: \(error)") // delete this code in final commit
            return nil
        }
    }
    
    // Transforms Data back into an array of strings
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        // Ensure the input is Data
        guard let data = value as? Data else { return nil }
        
        // Unarchive the Data into an array of strings
        do {
            let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self], from: data)
            return array as? [String]
        } catch {
            print("❌ Error unarchiving string array: \(error)") // delete this code in final commit
            return nil
        }
    }
}
