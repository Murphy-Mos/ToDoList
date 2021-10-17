//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit
import FittedSheets //Обычно использую cocoaPods, но xCode 13 никак не даст мне сделать pod init))

protocol TaskDetailRouterInput {
    
    func showChangePhotoPopup(delegate: ChangeImagePopupDelegate, imageInteractionService: ImageInteractionService?)
}

final class TaskDetailRouter {
    
    // MARK: - Properties
    
    private unowned let view: UIViewController
    
    
    // MARK: - Init
    
    init(view: UIViewController) {
        self.view = view
    }
    
}

extension TaskDetailRouter: TaskDetailRouterInput {
    
    func showChangePhotoPopup(delegate: ChangeImagePopupDelegate, imageInteractionService: ImageInteractionService?) {
        let popUp = ChangeImagePopupVC.assemble(delegate: delegate, imageInteractionService: imageInteractionService)
        let sheetController = SheetViewController(controller: popUp, sizes: [.intrinsic], options: SheetOptions(useFullScreenMode: false, shrinkPresentingViewController: false))
        view.navigationController?.present(sheetController, animated: true)
    }
}

