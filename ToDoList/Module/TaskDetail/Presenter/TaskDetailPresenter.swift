//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

protocol TaskDetailViewOutput {
    func barButtonDidTap()
    func saveButtonDidTap(taskInfo: TaskModel?, title: String, description: String?)
}

protocol TaskDetailInteractorOutput: AnyObject {
    func didSuccessSaveTask()
}

protocol ChangeImagePopupDelegate {
    func imageWasChanged(path: String, image: UIImage)
}

final class TaskDetailPresenter {
    
    // MARK: - Properties
    
    weak var view: TaskDetailViewInput?
    var router: TaskDetailRouterInput?
    var interactor: TaskDetailInteractorInput?
    
    private var imageUrl = ""
    
}


// MARK: - TaskDetailViewOutput
extension TaskDetailPresenter: TaskDetailViewOutput {
    
    func barButtonDidTap() {
        router?.showChangePhotoPopup(delegate: self)
    }
    
    func saveButtonDidTap(taskInfo: TaskModel?, title: String, description: String?) {
        if let existTask = taskInfo {
            
            interactor?.changeExistTask(task: existTask, title: title, description: description, image: nil)
        } else {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            
            let task = TaskModel()
            task.title = title
            task.taskDescription = description ?? ""
            task.dateCreated = date
            task.image = imageUrl
            
            interactor?.saveNewTask(task: task)
        }
    }
}


// MARK: - TaskDetailInteractorOutput
extension TaskDetailPresenter: TaskDetailInteractorOutput {
    func didSuccessSaveTask() {
        view?.popToRootVC()
    }
}


// MARK: - ChangeImagePopupDelegate
extension TaskDetailPresenter: ChangeImagePopupDelegate {
    
    func imageWasChanged(path: String, image: UIImage) {
        view?.setTaskImage(image: image)
        imageUrl = path
    }
}
