//
//  TaskModel.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import Foundation
import RealmSwift

struct TaskModel2 {
    let id: Int
    let title: String
    let description: String
    let dateCreated: Int
    let image: String?
    var isCompleted: Bool
}

@objcMembers
class TaskModel: Object {
//    dynamic var id: Int = 0
    dynamic var title: String = String()
    dynamic var taskDescription: String = String()
    dynamic var dateCreated: Date = Date()
    dynamic var image: String? = nil
    dynamic var isCompleted: Bool = false
    dynamic var completionDate: Date? = Date()
}
