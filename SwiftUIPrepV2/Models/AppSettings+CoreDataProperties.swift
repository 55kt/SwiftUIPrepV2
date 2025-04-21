//
//  AppSettings+CoreDataProperties.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 21/4/25.
//
//

import Foundation
import CoreData


extension AppSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSettings> {
        return NSFetchRequest<AppSettings>(entityName: "AppSettings")
    }

    @NSManaged public var language: String?

}

extension AppSettings : Identifiable {

}
