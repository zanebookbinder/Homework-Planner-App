//
//  Class_CD+CoreDataProperties.swift
//  HomeworkPlanner
//
//  Created by Zane Bookbinder on 5/1/20.
//  Copyright © 2020 Zane Bookbinder. All rights reserved.
//
//

import Foundation
import CoreData


extension Class_CD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Class_CD> {
        return NSFetchRequest<Class_CD>(entityName: "Class_CD")
    }

    @NSManaged public var class_name: String?
    @NSManaged public var tasks: NSSet?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID
    @NSManaged public var taskHistory: NSSet?
    
    public var wrappedClassName: String {
        class_name ?? "Unknown"
    }
    
    public var taskArray: [Task_CD] {
        let set = tasks as? Set<Task_CD> ?? []
        
        return set.sorted {
            $0.createdAt! < $1.createdAt!
        }
    }
    
    public var taskHistoryArray: [Task_CD] {
        let set = taskHistory as? Set<Task_CD> ?? []
        
        return set.sorted {
            $0.createdAt! < $1.createdAt!
        }
    }
}

// MARK: Generated accessors for tasks
extension Class_CD {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task_CD)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task_CD)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension Class_CD {

    @objc(addTaskHistoryObject:)
    @NSManaged public func addToTaskHistory(_ value: Task_CD)

    @objc(removeTaskHistoryObject:)
    @NSManaged public func removeFromTaskHistory(_ value: Task_CD)
}
