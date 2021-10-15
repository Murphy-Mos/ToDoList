//
//  ToDoListDataConverter.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import Foundation

protocol ToDoListDataConverterInput {
    func convert(tasks: [TaskModel], delegate: TaskCellDelegate, newTaskList: @escaping ([TaskModel]) -> Void) -> ToDoListViewModel
}

final class ToDoListDataConverter {  }


// MARK: - OrderDetailsDataConverterInput
extension ToDoListDataConverter: ToDoListDataConverterInput {
    
    private typealias Row = ToDoListViewModel.Section.Row
    private typealias Section = ToDoListViewModel.Section
    private typealias TaskConfigurator = TableCellConfigurator<TaskCell, TaskCell.Model>
    
    func convert(tasks: [TaskModel], delegate: TaskCellDelegate, newTaskList: @escaping ([TaskModel]) -> Void) -> ToDoListViewModel {
                
        var sections: [Section] = []
        
        var notCompletedTask: [TaskModel] = []
        var completedTask: [TaskModel] = []
        
        tasks.forEach({ $0.isCompleted ? completedTask.append($0) : notCompletedTask.append($0) })
        completedTask = completedTask.sorted(by: {
            $0.completionDate?.compare($1.completionDate!) == .orderedAscending
        })
        
        newTaskList(notCompletedTask + completedTask)
        
        let newTasks = newTaskSection(tasks: notCompletedTask, delegate: delegate)
        sections.append(newTasks)
        
        let completedTasks = completedTaskSection(tasks: completedTask, delegate: delegate)
        sections.append(completedTasks)

        return ToDoListViewModel(sections: sections)
    }
    
    private func newTaskSection(tasks: [TaskModel], delegate: TaskCellDelegate) -> Section {
        
        var rows: [Row] = []
        
        guard !tasks.isEmpty else {
            return Section(headerTitle: nil,
                           rows: rows)
        }
        
        tasks.forEach { task in
            
            let taskModel = TaskCell.Model(task: task, delegate: delegate)
            let taskConfigurator = TaskConfigurator(item: taskModel)
            rows.append(Row(configurator: taskConfigurator))
        }
        
        return Section(headerTitle: "Новые задачи (свайп для удаления)",
                       rows: rows)
    }
    
    private func completedTaskSection(tasks: [TaskModel], delegate: TaskCellDelegate) -> Section {
        
        var rows: [Row] = []
        
        guard !tasks.isEmpty else {
            return Section(headerTitle: nil,
                           rows: rows)
        }
        
        tasks.forEach { task in
            
            let taskModel = TaskCell.Model(task: task, delegate: delegate)
            let taskConfigurator = TaskConfigurator(item: taskModel)
            rows.append(Row(configurator: taskConfigurator))
        }
        
        
        return Section(headerTitle: "Выполненные задачи",
                       rows: rows)
    }
}
