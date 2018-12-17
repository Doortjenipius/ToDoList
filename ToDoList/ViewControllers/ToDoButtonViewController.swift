//
//  ToDoButton.swift
//  ToDoList
//
//  Created by doortje on 28/11/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import UIKit

class ToDoButtonViewController: UITableViewController {
    
    // Outlet voor aan buttons, text field, labels, text views, bar buttons en date pickers.
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    // Laadt je een todo alleen saven als er tekst is ingevoerd.
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // Date picker is in principe hidden.
    var isEndDatePickerHidden = true
    var todo: ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePickerView.date = todo.dueDate
            notesTextView.text = todo.notes
        } else {
            dueDatePickerView.date =
                // Code die ook minuten en seconde bij de datum aangeeft.
                Date().addingTimeInterval(24*60*60)
        }
        // Code die de datum die de Date Picker aangeeft opslaat.
        updateDueDateLabel(date: dueDatePickerView.date)
        updateSaveButtonState()
    }
    
    // Formateert de datum in het juiste format (korte stijl)
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    // Functie wordt aangeroepen als een datum wordt veranderd.
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    // Gebruiker kan geen to do saven zonder een titel.
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    // Als return is ingedrukt verdwijnt het toetsenbord.
    @IBAction func returnPressed(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    // Code voor de complete button. Veranderd de button van complete naar niet complete.
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        // Code die de hoogte van de cellen aangeeft.
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        // Switch statement die de hoogte van de rij veranderd om zo de de rijen in het aanmaken van een to do correct te laten zien.
        switch(indexPath) {
        case [1,0]: //Due Date Cell
            return isEndDatePickerHidden ? normalCellHeight:
            largeCellHeight
        case [2,0]: //Notes Cell
            return largeCellHeight
        default: return normalCellHeight
        }
    }
    // Code die de kleur aangeeft als er op de date picker wordt geklikt. Hij enabeld hem als het ware.
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            isEndDatePickerHidden = !isEndDatePickerHidden
            
            dueDateLabel.textColor =
                isEndDatePickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default: break
        }
    }
    
    // Segue die de juiste data over de to do doorgeeft en opslaat in ToDo.
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        todo = ToDo(title: title, isComplete: isComplete, dueDate:
            dueDate, notes: notes)
    }
    
}
