//
//  AuthVC.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import UIKit

protocol AuthViewInput: AnyObject {
    func showError()
}

final class AuthVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - Properties
    
    var presenter: AuthViewOutput?
    
    //MARK: - IBActions
    
    @IBAction func loginDidTap(_ sender: Any) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else { return }
        presenter?.loginDidTap(login: login, password: password)
    }
}


extension AuthVC: AuthViewInput {
    
    func showError() {
        showOneActionAlert(title: "Ошибка", message: "Логин или пароль неверны", buttonText: "Ok")
    }
}
