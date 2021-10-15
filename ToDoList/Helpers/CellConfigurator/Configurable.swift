//
//  Configurable.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import Foundation

protocol Configurable {
    associatedtype Model
    func configure(with model: Model)
}
