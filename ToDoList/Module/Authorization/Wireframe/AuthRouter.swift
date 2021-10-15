//
//  AuthRouter.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import UIKit

protocol AuthRouterInput {
    func openToDoListVC()
}

final class AuthRouter {
    
    // MARK: - Properties
    
    private unowned let view: UIViewController
    
    
    // MARK: - Init
    
    init(view: UIViewController) {
        self.view = view
    }
}


//MARK: - AuthRouterInput
extension AuthRouter: AuthRouterInput {
    
    func openToDoListVC() {
        let vc = ToDoListAssembly.assembleModule()
        view.navigationController?.pushViewController(vc, animated: true)
    }
}
