//
//  CollectionExt.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
