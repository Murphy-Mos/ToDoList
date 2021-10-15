//
//  AuthAssembly.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import UIKit

final class AuthAssembly {
    
    static func assembleModule() -> UIViewController {
        
        guard let view = UIStoryboard(name: "AuthVC", bundle: nil).instantiateViewController(withIdentifier: "AuthVC") as? AuthVC else { return UIViewController() }
        
        let presenter = AuthPresenter()
        let router = AuthRouter(view: view)
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        return view
    }
}
