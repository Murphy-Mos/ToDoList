//
//  AuthPresenter.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import Foundation

protocol AuthViewOutput {
    func loginDidTap(login: String, password: String)
}

final class AuthPresenter {
    
    //MARK: - Properties
    
    weak var view: AuthViewInput?
    var router: AuthRouterInput?
    
    private let profileLogin = "1111"
    private let profilepassword = "2222"
}


// MARK: - CancelOrderViewOutput
extension AuthPresenter: AuthViewOutput {
    
    func loginDidTap(login: String, password: String) {
        
        guard login != profileLogin,
              password != profilepassword else {
                  view?.showError()
                  return
              }
        
        router?.openToDoListVC()
    }
}
