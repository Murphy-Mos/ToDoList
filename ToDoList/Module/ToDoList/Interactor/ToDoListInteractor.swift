//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 15.10.2021.
//

import Foundation

protocol ToDoListInteractorInput {
    func obtainTasks()
    func removeTask(task: TaskModel)
    func changeTaskCompleted(task: TaskModel, complitedDate: Date?)
}
final class ToDoListInteractor {
    
    weak var presenter: ToDoListInteractorOutput?
    private let service: TasksService
    
    init(service: TasksService) {
        self.service = service
    }
}

extension ToDoListInteractor: ToDoListInteractorInput {
    
    func obtainTasks() {
        service.read(TaskModel.self) { [weak self] taskList in
            self?.presenter?.didSuccessToObtainTasks(with: taskList)
        }
    }
    
    func removeTask(task: TaskModel) {
        service.delete(object: task) { [weak self] isSuccess in
            if isSuccess {
                self?.presenter?.didSuccessRemoveTask()
            }
        }
    }
    
    func changeTaskCompleted(task: TaskModel, complitedDate: Date?) {
        service.updateCompletedTask(object: task, complitedDate: complitedDate) { [weak self] isSuccess in
            if isSuccess {
//                self?.presenter?.didSuccessRemoveTask(index: index)
            }
        }
    }
}
