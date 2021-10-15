//
//  TaskDetailAssembly.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

final class TaskDetailAssembly {
    
    static func assembleModule(task: TaskModel?) -> UIViewController {
        
        guard let view = UIStoryboard(name: "TaskDetailVC", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailVC") as? TaskDetailVC else { return UIViewController() }
        
        let presenter = TaskDetailPresenter()
        let router = TaskDetailRouter(view: view)
        let service = TasksServiceImp()
        let interactor = TaskDetailInteractor(service: service)

        view.presenter = presenter
        view.taskInfo = task
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}

