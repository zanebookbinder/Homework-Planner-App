//
//  Task_CD+CoreDataProperties.swift
//  HomeworkPlanner
//
//  Created by Zane Bookbinder on 5/1/20.
//  Copyright © 2020 Zane Bookbinder. All rights reserved.
//
//

import Foundation
import CoreData


extension Task_CD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task_CD> {
        return NSFetchRequest<Task_CD>(entityName: "Task_CD")
    }

    @NSManaged public var dueDate: String?
    @NSManaged public var text: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID
    @NSManaged public var isUrgent: Bool
    
    
    @NSManaged public var class_name: Class_CD?
    
    public var wrappedText: String {
        text ?? "Unknown"
    }
    
    public var wrappedDueDate: String {
        dueDate ?? "Unknown"
    }
}
