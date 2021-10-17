//
//  ToDoListDataConverter.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import Foundation
import UIKit

protocol ToDoListDataConverterInput {
    func convert(tasks: [TaskModel], delegate: TaskCellDelegate, imageInteractionService: ImageInteractionService, newTaskList: @escaping ([TaskModel]) -> Void) -> ToDoListViewModel
}

final class ToDoListDataConverter {  }


// MARK: - OrderDetailsDataConverterInput
extension ToDoListDataConverter: ToDoListDataConverterInput {
    
    private typealias Row = ToDoListViewModel.Section.Row
    private typealias Section = ToDoListViewModel.Section
    private typealias TaskConfigurator = TableCellConfigurator<TaskCell, TaskCell.Model>
    
    func convert(tasks: [TaskModel], delegate: TaskCellDelegate, imageInteractionService: ImageInteractionService, newTaskList: @escaping ([TaskModel]) -> Void) -> ToDoListViewModel {
                
        var sections: [Section] = []
        
        var notCompletedTask: [TaskModel] = []
        var completedTask: [TaskModel] = []
        
        tasks.forEach { task in
            
            task.isCompleted ? completedTask.append(task) : notCompletedTask.append(task)
            
            var image: UIImage? {
                didSet {
                    task.uiImage = image
                }
            }
            
            let imagePath = task.image
            
            DispatchQueue.global().async {
                image = imageInteractionService.loadImageFromDiskWith(fileName: imagePath ?? "") ?? UIImage()
            }
        }
        
        completedTask = completedTask.sorted(by: {
            $0.completionDate?.compare($1.completionDate!) == .orderedAscending
        })
        
        newTaskList(notCompletedTask + completedTask)
        
        let newTasks = newTaskSection(tasks: notCompletedTask, delegate: delegate, imageInteractionService: imageInteractionService)
        sections.append(newTasks)
        
        let completedTasks = completedTaskSection(tasks: completedTask, delegate: delegate, imageInteractionService: imageInteractionService)
        sections.append(completedTasks)

        return ToDoListViewModel(sections: sections)
    }
    
    private func newTaskSection(tasks: [TaskModel], delegate: TaskCellDelegate, imageInteractionService: ImageInteractionService) -> Section {
        
        var rows: [Row] = []
        
        guard !tasks.isEmpty else {
            return Section(headerTitle: nil,
                           rows: rows)
        }
        
        tasks.forEach { task in
            
            let taskModel = TaskCell.Model(task: task, delegate: delegate, imageInteractionService: imageInteractionService)
            let taskConfigurator = TaskConfigurator(item: taskModel)
            rows.append(Row(configurator: taskConfigurator))
        }
        
        return Section(headerTitle: "Новые задачи (свайп для удаления)",
                       rows: rows)
    }
    
    private func completedTaskSection(tasks: [TaskModel], delegate: TaskCellDelegate, imageInteractionService: ImageInteractionService) -> Section {
        
        var rows: [Row] = []
        
        guard !tasks.isEmpty else {
            return Section(headerTitle: nil,
                           rows: rows)
        }
        
        tasks.forEach { task in
            
            let taskModel = TaskCell.Model(task: task, delegate: delegate, imageInteractionService: imageInteractionService)
            let taskConfigurator = TaskConfigurator(item: taskModel)
            rows.append(Row(configurator: taskConfigurator))
        }
        
        
        return Section(headerTitle: "Выполненные задачи",
                       rows: rows)
    }
}
