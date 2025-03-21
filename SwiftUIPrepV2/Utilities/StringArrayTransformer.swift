//
//  StringArrayTransformer.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 21/3/25.
//

import Foundation

@objc(StringArrayTransformer)
class StringArrayTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [String] else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: true)
            return data
        } catch {
            print("‼️🆘 Error archiving string array ‼️🆘: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self], from: data)
            return array as? [String]
        } catch {
            print("‼️🆘 Error unarchiving string array ‼️🆘: \(error)")
            return nil
        }
    }
}
