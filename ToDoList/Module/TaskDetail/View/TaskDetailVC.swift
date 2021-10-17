//
//  TaskDetailVC.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

protocol TaskDetailViewInput: AnyObject {
    func popToRootVC()
    func setTaskImage(image: UIImage?)
    func showError()
}

final class TaskDetailVC: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    var presenter: TaskDetailViewOutput?
    
    private let descriptionPlaceHolder = "Описание задачи"
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var taskImage: UIImageView!
    @IBOutlet private weak var taskTitleTextField: UITextField!
    @IBOutlet private weak var taskDescriptionTextView: TextViewPlaceHolder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction private func barButtonDidTap(_ sender: Any) {
        presenter?.barButtonDidTap()
    }
    
    @IBAction func saveButtonDidTap(_ sender: Any) {
        guard let title = taskTitleTextField.text,
              !title.isEmpty else {
                  showErrorAlert()
                  return
              }
        
        let description = taskDescriptionTextView.text != descriptionPlaceHolder ? taskDescriptionTextView.text : nil
        presenter?.saveButtonDidTap(title: title, description: description)
    }
    
    private func setupView() {
        taskDescriptionTextView.placeHolder = descriptionPlaceHolder
        
        if let taskInfo = presenter?.fetchTask() {
            taskTitleTextField.text = taskInfo.title
            taskDescriptionTextView.text = taskInfo.taskDescription
            
            if let image = presenter?.fetchTaskImage() {
                taskImage.isHidden = false
                taskImage.image = image
            } else {
                taskImage.isHidden = true
            }
            
            if taskInfo.taskDescription != "" {
                taskDescriptionTextView.textColor = .black
            } else {
                taskDescriptionTextView.text =   descriptionPlaceHolder
            }
        } else {
            taskImage.isHidden = true
        }
    }
    
    private func showErrorAlert() {
        let errorAlert = UIAlertController(title: "Ошибка", message: "Введите название задачи", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true)
    }
}


//MARK: - TaskDetailViewInput
extension TaskDetailVC: TaskDetailViewInput {
    
    func popToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setTaskImage(image: UIImage?) {
        if let image = image {
            taskImage.isHidden = false
            taskImage.image = image
        } else {
            taskImage.isHidden = true
            taskImage.image = nil
        }
    }
    
    func showError() {
        showOneActionAlert(title: "Ошибка", message: "Произошла неизвестная ошибка", buttonText: "Ok")
    }
}
