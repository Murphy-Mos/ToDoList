//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import Foundation
import UIKit

protocol ToDoListViewOutput {
    func viewIsReady()
    func newTaskDidTap()
}

protocol ToDoListInteractorOutput: AnyObject {
    func didSuccessToObtainTasks(with model: [TaskModel])
    func didSuccessRemoveTask()
}

final class ToDoListPresenter {
    
    // MARK: - Properties

    weak var view: ToDoListViewInput?
    var interactor: ToDoListInteractorInput?
    var router: ToDoListRouterInput?
    let dataConverter: ToDoListDataConverterInput
    
    private var taskList: [TaskModel]?
    
    // MARK: - init

    init(dataConverter: ToDoListDataConverterInput) {
        self.dataConverter = dataConverter
    }
    
    private func getNeededTask(section: Int, index: Int) -> TaskModel {
        var notCompletedTask: [TaskModel] = []
        var completedTask: [TaskModel] = []
        
        taskList?.forEach({ $0.isCompleted ? completedTask.append($0) : notCompletedTask.append($0) })
        let task: TaskModel
        switch section {
        case 0:
            task = notCompletedTask[index]
            notCompletedTask.remove(at: index)
        default:
            task = completedTask[index]
            completedTask.remove(at: index)
        }
        
        taskList = notCompletedTask + completedTask
        
        return task
    }
}


// MARK: - ToDoListViewOutput
extension ToDoListPresenter: ToDoListViewOutput {
    
    func viewIsReady() {
        interactor?.obtainTasks()
    }
    
    func newTaskDidTap() {
        router?.openNewTask()
    }
}


// MARK: - ToDoListTableViewManagerDelegate
extension ToDoListPresenter: ToDoListTableViewManagerDelegate {
    
    func didSelect(section: Int, index: Int) {
        
        let task = getNeededTask(section: section, index: index)
        router?.openDetailTask(task: task)
    }
    
    func didRemove(section: Int, index: Int) {
        
        let task = getNeededTask(section: section, index: index)
        interactor?.removeTask(task: task)
    }
}


// MARK: - ToDoListInteractorOutput
extension ToDoListPresenter: ToDoListInteractorOutput {
    
    func didSuccessToObtainTasks(with model: [TaskModel]) {
        taskList = model
        let viewModel = dataConverter.convert(tasks: model, delegate: self) { [weak self] newTaskList in
            self?.taskList = newTaskList
        }
        view?.updateView(with: viewModel)
    }
    
    func didSuccessRemoveTask() {
        let viewModel = dataConverter.convert(tasks: taskList ?? [], delegate: self) { [weak self] newTaskList in
            self?.taskList = newTaskList
        }
        view?.updateView(with: viewModel)
    }
}


// MARK: - TaskCellDelegate
extension ToDoListPresenter: TaskCellDelegate {
    
    func taskWasChecked(task: TaskModel) {
        
        if !task.isCompleted {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            
            interactor?.changeTaskCompleted(task: task, complitedDate: date)
            let viewModel = dataConverter.convert(tasks: taskList ?? [], delegate: self) { [weak self] newTaskList in
                self?.taskList = newTaskList
            }
            view?.updateView(with: viewModel)
        } else {
            interactor?.changeTaskCompleted(task: task, complitedDate: nil)
            interactor?.obtainTasks()
        }
        

    }
}
