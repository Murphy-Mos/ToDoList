//
//  ToDoListTableViewManager.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

import UIKit

protocol ToDoListTableViewManagerInput {
    func setup(tableView: UITableView)
    func update(with viewModel: ToDoListViewModel)
}

protocol ToDoListTableViewManagerDelegate: AnyObject {
    func didSelect(section: Int, index: Int)
    func didRemove(section: Int, index: Int)
}

final class ToDoListTableViewManager: NSObject {
    
    // MARK: - Properties

    weak var delegate: ToDoListTableViewManagerDelegate?
    private weak var tableView: UITableView?
    private var viewModel: ToDoListViewModel?
    
}

// MARK: - ToDoListTableViewManagerInput
extension ToDoListTableViewManager: ToDoListTableViewManagerInput {
    
    func setup(tableView: UITableView) {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView = tableView
    }
    
    func update(with viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        tableView?.reloadData()
    }
}


// MARK: - UITableViewDataSource
extension ToDoListTableViewManager: UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.sections[safe: section]?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = viewModel?.sections[safe: indexPath.section]?.rows[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseId, for: indexPath)
        row.configurator.configure(cell: cell)
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension ToDoListTableViewManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(section: indexPath.section, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let title = viewModel?.sections[section].headerTitle else {
            let header = UIView()
            header.backgroundColor = .clear
            return header
        }
        
        let header = TitleHeaderTableView(title: title)
        header.backgroundColor = .clear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if viewModel?.sections[section].headerTitle != nil {
            return 64
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.didRemove(section: indexPath.section, index: indexPath.row)
        }
    }
}
