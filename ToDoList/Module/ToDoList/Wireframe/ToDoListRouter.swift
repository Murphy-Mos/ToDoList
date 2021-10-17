//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

protocol ToDoListRouterInput {
    
    func openDetailTask(task: TaskModel, delegate: ToDoListDelegate)
    func openNewTask(delegate: ToDoListDelegate)
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
    
    func openDetailTask(task: TaskModel, delegate: ToDoListDelegate) {
        let vc = TaskDetailAssembly.assembleModule(task: task, delegate: delegate)
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openNewTask(delegate: ToDoListDelegate) {
        let vc = TaskDetailAssembly.assembleModule(task: nil, delegate: delegate)
        view.navigationController?.pushViewController(vc, animated: true)
    }
}
