//
//  TaskModel.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import Foundation
import RealmSwift
import UIKit

class TaskModel: Object {
    @objc dynamic var title: String = String()
    @objc dynamic var taskDescription: String = String()
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var image: String? = nil
    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var completionDate: Date? = Date()
    var uiImage: UIImage?
}
