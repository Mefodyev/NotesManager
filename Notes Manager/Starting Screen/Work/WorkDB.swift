//
//  WorkDB.swift
//  Notes Manager
//
//  Created by Alexey Mefodyev on 17.02.2020.
//  Copyright © 2020 LexMefodyev. All rights reserved.
//

import RealmSwift

class WorkTask : Object {
    
    @objc dynamic var name: String?
    @objc dynamic var beginDate: Date?
    @objc dynamic var deadlineDate: Date?
    @objc dynamic var imageData: Data?
    @objc dynamic var taskDescription: String?
   
    convenience init(name: String, beginDate: Date?, deadlineDate: Date?, imageData: Data?, taskDescription: String?) {
        self.init()
        self.name = name
        self.beginDate = beginDate
        self.deadlineDate = deadlineDate
        self.imageData = imageData
        self.taskDescription = taskDescription
    }
}
