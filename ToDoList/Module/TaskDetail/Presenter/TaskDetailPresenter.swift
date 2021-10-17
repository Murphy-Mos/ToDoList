//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

protocol TaskDetailViewOutput {
    func barButtonDidTap()
    func saveButtonDidTap(title: String, description: String?)
    func fetchTask() -> TaskModel?
    func fetchTaskImage() -> UIImage?
}

protocol TaskDetailInteractorOutput: AnyObject {
    func didSuccessSaveTask()
    func didFailureCallToService()
}

protocol ChangeImagePopupDelegate {
    func imageWasChanged(imageName: String)
    func removeImage()
    func imageLoadError()
}

final class TaskDetailPresenter {
    
    // MARK: - Properties
    
    weak var view: TaskDetailViewInput?
    var router: TaskDetailRouterInput?
    var interactor: TaskDetailInteractorInput?
    
    private let imageInteractionService: ImageInteractionService
    private let task: TaskModel?
    private let delegate: ToDoListDelegate
    private var imageUrl = ""
    
    // MARK: - init

    init(task: TaskModel?, imageInteractionService: ImageInteractionService, delegate: ToDoListDelegate) {
        self.task = task
        self.imageInteractionService = imageInteractionService
        self.delegate = delegate
    }
}


// MARK: - TaskDetailViewOutput
extension TaskDetailPresenter: TaskDetailViewOutput {
    
    func barButtonDidTap() {
        router?.showChangePhotoPopup(delegate: self, imageInteractionService: imageInteractionService)
    }
    
    func saveButtonDidTap(title: String, description: String?) {
        if let task = task {
            
            interactor?.changeExistTask(task: task, title: title, description: description, image: imageUrl)
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
    
    func fetchTask() -> TaskModel? { return task }
    
    func fetchTaskImage() -> UIImage? {
        return imageInteractionService.loadImageFromDiskWith(fileName: task?.image ?? "")
    }
}


// MARK: - TaskDetailInteractorOutput
extension TaskDetailPresenter: TaskDetailInteractorOutput {
    func didSuccessSaveTask() {
        delegate.taskWasSave()
        view?.popToRootVC()
    }
    
    func didFailureCallToService() {
        view?.showError()
    }
}


// MARK: - ChangeImagePopupDelegate
extension TaskDetailPresenter: ChangeImagePopupDelegate {
    
    func imageWasChanged(imageName: String) {
        let image = imageInteractionService.loadImageFromDiskWith(fileName: imageName) ?? UIImage()
        view?.setTaskImage(image: image)
        imageUrl = imageName
    }
    
    func removeImage() {
        imageUrl = ""
        view?.setTaskImage(image: nil)
    }
    
    func imageLoadError() {
        view?.showError()
    }
}
