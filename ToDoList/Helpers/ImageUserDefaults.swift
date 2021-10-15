//
//  ImageUserDefaults.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 15.10.2021.
//

import Foundation

final class ImageUserDefaults {
    
    //MARK: - Singleton
    
    static let shared = ImageUserDefaults()
    
    
    //MARK: - Keys
    
    let KEY_URL_SLOT_FOR_DOCUMENT = "KEY_URL_SLOT_FOR_DOCUMENT"
    
    //MARK: - Public Properties
    
    var newURLPath = ".png"
    var newURLSlot = 0 {
        didSet {
            UserDefaults.standard.removeObject(forKey: KEY_URL_SLOT_FOR_DOCUMENT)
            UserDefaults.standard.setValue(newURLSlot,
                                           forKey: KEY_URL_SLOT_FOR_DOCUMENT)
        }
    }
    
    //MARK: - Methods
    
    func generateNewURLPath() -> String {
        
        newURLSlot += 1
        let value = "image\(newURLSlot).png"
        return value
    }
}
