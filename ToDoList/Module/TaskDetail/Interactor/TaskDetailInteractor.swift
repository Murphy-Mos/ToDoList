//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 15.10.2021.
//

import Foundation

protocol TaskDetailInteractorInput {
    func saveNewTask(task: TaskModel)
    func changeExistTask(task: TaskModel, title: String, description: String?, image: String?)
}
final class TaskDetailInteractor {
    
    weak var presenter: TaskDetailInteractorOutput?
    private let service: TasksService
    
    init(service: TasksService) {
        self.service = service
    }
}

extension TaskDetailInteractor: TaskDetailInteractorInput {
    
    func saveNewTask(task: TaskModel) {
        service.save(object: task) { [weak self] isSuccess in
            if isSuccess {
                self?.presenter?.didSuccessSaveTask()
            }
        }
    }
    
    func changeExistTask(task: TaskModel, title: String, description: String?, image: String?) {
        service.update(object: task, title: title, description: description, image: image) { [weak self] isSuccess in
            if isSuccess {
                self?.presenter?.didSuccessSaveTask()
            }
        }
    }
}
