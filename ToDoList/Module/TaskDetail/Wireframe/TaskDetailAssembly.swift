//
//  TaskDetailAssembly.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

final class TaskDetailAssembly {
    
    static func assembleModule(task: TaskModel?, delegate: ToDoListDelegate) -> UIViewController {
        
        guard let view = UIStoryboard(name: "TaskDetailVC", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailVC") as? TaskDetailVC else { return UIViewController() }
        
        let router = TaskDetailRouter(view: view)
        let service = TasksServiceImp()
        let interactor = TaskDetailInteractor(service: service)
        let imageInteractionService = ImageInteractionServiceImpl()
        let presenter = TaskDetailPresenter(task: task, imageInteractionService: imageInteractionService, delegate: delegate)
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}

