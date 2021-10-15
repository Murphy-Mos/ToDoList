//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

protocol ToDoListRouterInput {
    
    func openDetailTask(task: TaskModel)
    func openNewTask()
}

final class ToDoListRouter {
    
    // MARK: - Properties
    
    private unowned let view: UIViewController
    
    
    // MARK: - Init
    
    init(view: UIViewController) {
        self.view = view
    }
    
}

extension ToDoListRouter: ToDoListRouterInput {
    
    func openDetailTask(task: TaskModel) {
        let vc = TaskDetailAssembly.assembleModule(task: task)
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openNewTask() {
        let vc = TaskDetailAssembly.assembleModule(task: nil)
        view.navigationController?.pushViewController(vc, animated: true)
    }
}
