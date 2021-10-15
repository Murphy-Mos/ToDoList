//
//  ToDoListVC.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import UIKit

protocol ToDoListViewInput: AnyObject {
    func updateView(with viewModel: ToDoListViewModel)
}

final class ToDoListVC: UIViewController {
    
    // MARK: - Properties
    
    var presenter: ToDoListViewOutput?
    var tableViewManager: ToDoListTableViewManagerInput?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewManager?.setup(tableView: tableView)
        presenter?.viewIsReady()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewManager?.setup(tableView: tableView)
        presenter?.viewIsReady()
    }
    //MARK: - Methods
    
    private func setupView() {
        navigationController?.viewControllers = [self]
    }
    
    //MARK: - IBActions
    
    @IBAction private func addTaskDidTap(_ sender: Any) {
        presenter?.newTaskDidTap()
    }
}

// MARK: - ToDoListViewInput
extension ToDoListVC: ToDoListViewInput {
    
    func updateView(with viewModel: ToDoListViewModel) {
        tableView.isHidden = false
        tableViewManager?.update(with: viewModel)
    }
}
