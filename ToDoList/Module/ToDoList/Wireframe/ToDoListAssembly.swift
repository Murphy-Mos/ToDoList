//
//  ToDoListAssembly.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import UIKit

final class ToDoListAssembly {
    
    static func assembleModule() -> UIViewController {
        
        guard let view = UIStoryboard(name: "ToDoListVC", bundle: nil).instantiateViewController(withIdentifier: "ToDoListVC") as? ToDoListVC else { return UIViewController() }
        
        let dataConverter = ToDoListDataConverter()
        let tableViewManager = ToDoListTableViewManager()
        let router = ToDoListRouter(view: view)
        let service = TasksServiceImp()
        let interactor = ToDoListInteractor(service: service)
        let imageInteractionService = ImageInteractionServiceImpl()
        let presenter = ToDoListPresenter(dataConverter: dataConverter, imageInteractionService: imageInteractionService)
        
        view.presenter = presenter
        view.tableViewManager = tableViewManager
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        tableViewManager.delegate = presenter
        
        return view
    }
}
