//
//  RealmService.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 15.10.2021.
//

import Foundation
import RealmSwift

protocol TasksService {
    func read<T: Object>(_: T.Type, completion: @escaping ([T]) -> Void)
    func save(object: Object, completion: @escaping (_ isSuccess: Bool) -> Void)
    func delete(object: Object, completion: @escaping (_ isSuccess: Bool) -> Void)
    func update(object: TaskModel, title: String, description: String?, image: String?, completion: @escaping (_ isSuccess: Bool) -> Void)
    func updateCompletedTask(object: TaskModel, complitedDate: Date?, completion: @escaping (_ isSuccess: Bool) -> Void)
}

final class TasksServiceImp: TasksService {
    private let realm = try! Realm()
    
    func read<T: Object>(_: T.Type, completion: @escaping ([T]) -> Void) {
        completion(Array(realm.objects(T.self)))
    }
    
    func save(object: Object, completion: @escaping (_ isSuccess: Bool) -> Void) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.add(object)
                    completion(true)
                }
            } catch {
                completion(false)
            }
        }
    }
    
    func delete(object: Object, completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            try realm.write {
                realm.delete(object)
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
    
    
    func update(object: TaskModel, title: String, description: String?, image: String?, completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            try realm.write {
                object.title = title
                object.taskDescription = description ?? ""
                object.image = image
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
    
    func updateCompletedTask(object: TaskModel, complitedDate: Date?, completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            try realm.write {
                object.isCompleted.toggle()
                if let date = complitedDate {
                    object.completionDate = date
                } else {
                    object.completionDate = nil
                }
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
}

