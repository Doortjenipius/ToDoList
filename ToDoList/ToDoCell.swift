//
//  ToDoCell.swift
//  ToDoList
//
//  Created by doortje on 28/11/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import UIKit


@objc protocol ToDoCellDelegate: class {
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    
    var delegate: ToDoCellDelegate?
    
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.checkmarkTapped(sender: self)
    }
}
