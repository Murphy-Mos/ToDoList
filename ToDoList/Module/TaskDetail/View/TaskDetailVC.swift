//
//  TaskDetailVC.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

protocol TaskDetailViewInput: AnyObject {
    func popToRootVC()
    func setTaskImage(image: UIImage)
}

final class TaskDetailVC: UIViewController {
    
    // MARK: - Properties
    
    var presenter: TaskDetailViewOutput?
    var taskInfo: TaskModel?
    
    private let descriptionPlaceHolder = "Описание задачи"
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var taskImage: UIImageView!
    @IBOutlet private weak var taskTitleTextField: UITextField!
    @IBOutlet private weak var taskDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction private func barButtonDidTap(_ sender: Any) {
        presenter?.barButtonDidTap()
    }
    
    @IBAction func saveButtonDidTap(_ sender: Any) {
        guard let title = taskTitleTextField.text,
              !title.isEmpty else { return }
        let description = taskDescriptionTextView.text != descriptionPlaceHolder ? taskDescriptionTextView.text : nil
        presenter?.saveButtonDidTap(taskInfo: taskInfo, title: title, description: description)
    }
    
    private func setupView() {
        taskDescriptionTextView.delegate = self
        
        if let taskInfo = taskInfo {
            taskTitleTextField.text = taskInfo.title
            taskDescriptionTextView.text = taskInfo.taskDescription
            
            if taskInfo.image == nil {
                taskImage.isHidden = true
            } else {
                taskImage.isHidden = false
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
}


//MARK: - TaskDetailViewInput
extension TaskDetailVC: TaskDetailViewInput {
    
    func popToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setTaskImage(image: UIImage) {
        taskImage.image = image
    }
}


// MARK: - UITextViewDelegate
extension TaskDetailVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = descriptionPlaceHolder
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

         else if textView.text == descriptionPlaceHolder && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }

        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.text == descriptionPlaceHolder {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == descriptionPlaceHolder {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionPlaceHolder
            textView.textColor = UIColor.lightGray
        }
    }
}
