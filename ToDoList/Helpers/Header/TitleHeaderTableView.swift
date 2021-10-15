//
//  TitleHeaderView.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

final class TitleHeaderTableView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    

    // MARK: - Init
    
    init(title: String) {
        super.init(frame: .zero)
        Bundle.main.loadNibNamed("TitleHeaderTableView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        titleLabel.text = title
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
