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
    func didFailureCallToService()
}

protocol ToDoListDelegate {
    func taskWasSave()
}

final class ToDoListPresenter {
    
    // MARK: - Properties

    weak var view: ToDoListViewInput?
    var interactor: ToDoListInteractorInput?
    var router: ToDoListRouterInput?
    
    private let dataConverter: ToDoListDataConverterInput
    private let imageInteractionService: ImageInteractionService
    private var taskList: [TaskModel]?
    
    // MARK: - init

    init(dataConverter: ToDoListDataConverterInput, imageInteractionService: ImageInteractionService) {
        self.dataConverter = dataConverter
        self.imageInteractionService = imageInteractionService
    }
    
    private func getNeededTask(isDeleteSelectedTask: Bool, section: Int, index: Int) -> TaskModel? {
        var notCompletedTask: [TaskModel] = []
        var completedTask: [TaskModel] = []
        
        taskList?.forEach({ $0.isCompleted ? completedTask.append($0) : notCompletedTask.append($0) })
        let task: TaskModel?
        switch section {
        case 0:
            task = notCompletedTask[safe: index] ?? nil
            if isDeleteSelectedTask, notCompletedTask.count != 0 {
                notCompletedTask.remove(at: index)
            }
        default:
            task = completedTask[safe: index] ?? nil
            if isDeleteSelectedTask, completedTask.count != 0 {
                completedTask.remove(at: index)
            }
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
        router?.openNewTask(delegate: self)
    }
}


// MARK: - ToDoListTableViewManagerDelegate
extension ToDoListPresenter: ToDoListTableViewManagerDelegate {
    
    func didSelect(section: Int, index: Int) {
        
        guard let task = getNeededTask(isDeleteSelectedTask: false, section: section, index: index) else { return }
        router?.openDetailTask(task: task, delegate: self)
    }
    
    func didRemove(section: Int, index: Int) {
        
        guard let task = getNeededTask(isDeleteSelectedTask: true, section: section, index: index) else { return }
        interactor?.removeTask(task: task)
    }
}


// MARK: - ToDoListInteractorOutput
extension ToDoListPresenter: ToDoListInteractorOutput {
    
    func didSuccessToObtainTasks(with model: [TaskModel]) {
        taskList = model
        let viewModel = dataConverter.convert(tasks: model, delegate: self, imageInteractionService: imageInteractionService) { [weak self] newTaskList in
            self?.taskList = newTaskList
        }
        view?.updateView(with: viewModel)
    }
    
    func didSuccessRemoveTask() {
        let viewModel = dataConverter.convert(tasks: taskList ?? [], delegate: self, imageInteractionService: imageInteractionService) { [weak self] newTaskList in
            self?.taskList = newTaskList
        }
        view?.updateView(with: viewModel)
    }
    
    func didFailureCallToService() {
        view?.showError()
    }
}


// MARK: - ToDoListInteractorOutput
extension ToDoListPresenter: ToDoListDelegate {
    
    func taskWasSave() {
        view?.reloadScreen()
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
            let viewModel = dataConverter.convert(tasks: taskList ?? [], delegate: self, imageInteractionService: imageInteractionService) { [weak self] newTaskList in
                self?.taskList = newTaskList
            }
            view?.updateView(with: viewModel)
        } else {
            interactor?.changeTaskCompleted(task: task, complitedDate: nil)
            interactor?.obtainTasks()
        }
    }
}
