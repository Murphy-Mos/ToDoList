//
//  TaskCell.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

protocol TaskCellDelegate {
    func taskWasChecked(task: TaskModel)
}

final class TaskCell: UITableViewCell {
    
    private var task: TaskModel?
    private var delegate: TaskCellDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var taskImage: UIImageView!

    // MARK: - IBActions
    
    @IBAction func chekButtonDidTap(_ sender: Any) {
        
        guard let task = task else { return }

        delegate?.taskWasChecked(task: task)
        
        let image = task.isCompleted ? UIImage(named: "ic_check") : UIImage(named: "ic_not_check")
        checkButton.setImage(image, for: .normal)
    }
}

// MARK: - Configurable
extension TaskCell: Configurable {
    
    struct Model {
        var task: TaskModel
        var delegate: TaskCellDelegate
    }
    
    func configure(with model: Model) {
        
        self.task = model.task
        self.delegate = model.delegate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateInStringFormat = dateFormatter.string(from: model.task.dateCreated)
        
        titleLabel.text = model.task.title
        dateLabel.text = dateInStringFormat
        taskImage.image =  UIImage(named: model.task.image ?? "")
        let checkImage = model.task.isCompleted ? UIImage(named: "ic_check") : UIImage(named: "ic_not_check")
        checkButton.setImage(checkImage, for: .normal)
    }
}
