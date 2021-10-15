//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 13.10.2021.
//

struct ToDoListViewModel {
    
    let sections: [Section]
    
    struct Section {
        
        let headerTitle: String?
        let rows: [Row]
        
        struct Row {
            
            let configurator: TableCellConfiguratorProtocol
           
            var reuseId: String {
                return type(of: configurator).reuseId
            }
        }
    }
}
