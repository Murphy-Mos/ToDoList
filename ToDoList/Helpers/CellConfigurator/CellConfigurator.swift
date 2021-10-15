//
//  CellConfigurator.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

protocol CellConfigurator {
    
    static var reuseId: String { get }
    
    func configure(cell: UIView)
    func associatedValue<T>() -> T?
}


// MARK: - Table

protocol TableCellConfiguratorProtocol: CellConfigurator {
    var cellHeight: CGFloat { get }
    var headerHeight: CGFloat { get }
}


// MARK: - Collection

protocol CollectionCellConfiguratorProtocol: CellConfigurator {
    var size: CGSize { get }
}
