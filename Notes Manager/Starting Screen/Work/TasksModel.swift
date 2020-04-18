//
//  WorkDB.swift
//  Notes Manager
//
//  Created by Alexey Mefodyev on 17.02.2020.
//  Copyright © 2020 LexMefodyev. All rights reserved.
//

import RealmSwift


class Task : Object {

    @objc dynamic var name: String?
    @objc dynamic var taskDescription: String?
    @objc dynamic var taskDate: Date?
    @objc dynamic var imageData: Data?
    @objc dynamic var workTask: WorkTask!

    convenience init(name: String, taskDescription: String?, taskDate: Date?, imageData: Data?) {
        self.init()
        self.name = name
        self.taskDate = taskDate
        self.taskDescription = taskDescription
        self.imageData = imageData
    }
}

class WorkTask : Object {
    @objc dynamic var name: String? = ""
    @objc dynamic var taskDescription: String? = ""
    @objc dynamic var taskDate: Date? = Date()
    @objc dynamic var imageData: Data? = Data()
    @objc dynamic var taskLocation: String? = ""
    @objc dynamic var oneHourReminder: Bool = false
    @objc dynamic var twoHoursReminder: Bool = false
    @objc dynamic var oneDayReminder: Bool = false


    convenience init(name: String, taskDescription: String?, taskDate: Date?, imageData: Data?, taskLocation: String?, oneHourReminder: Bool, twoHoursReminder: Bool, oneDayReminder: Bool) {
        self.init()
        self.name = name
        self.taskDate = taskDate
        self.taskDescription = taskDescription
        self.imageData = imageData
        self.taskLocation = taskLocation
        self.oneHourReminder = oneHourReminder
        self.twoHoursReminder = twoHoursReminder
        self.oneDayReminder = oneDayReminder
    }
}
