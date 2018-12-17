//
//  ToDoCell.swift
//  ToDoList
//
//  Created by doortje on 28/11/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import UIKit

// Code die de cell doorgeeft aan het delegate.
@objc protocol ToDoCellDelegate: class {
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    // Kan de door middel van het property data doorgeven aan ToDoCellDelegate.
    var delegate: ToDoCellDelegate?
    
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Informeert de delegate dat de checkmark button is aangeklikt.
    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.checkmarkTapped(sender: self)
    }
    
    
}
