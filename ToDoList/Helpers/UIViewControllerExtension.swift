//
//  UIViewControllerExtension.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 16.10.2021.
//

import UIKit

extension UIViewController {
    
    func showOneActionAlert(title: String, message: String, buttonText: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonText, style: .cancel)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true)
    }
}
