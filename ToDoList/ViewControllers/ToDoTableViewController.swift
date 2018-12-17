//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by doortje on 27/11/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    

// Lege array waar de todos kunnen worden opgeslagen.
    var todos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
// Linker button in de navigationbar is een edit button.
        navigationItem.leftBarButtonItem = editButtonItem

// Checkt of de todos zelf aangemaakte todos zijn uit loadToDos of of de sample todos moeten worden geladen.
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDos()
        }
    }
    
// Aantal sections is gelijk aan het aantal todos.
    override func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
// Configureert de cellen.
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier:
                "ToDoCellIdentifier") as? ToDoCell else {
                    fatalError("Could not dequeue a cell")
        }
// Laadt de correcte data van de todo in de cell.
        cell.delegate = self
        let todo = todos[indexPath.row]
// Zet het titleLabel naar de correcte titel van de to do.
        cell.titleLabel?.text = todo.title
// Code om aan te geven of de complete button is aangevinkt of niet.
        cell.isCompleteButton.isSelected = todo.isComplete

        return cell
    }
// Code die het mogelijk maakt dat je een rij kan editen, zodat je to do's kan verwijderen.
    override func tableView(_ tableView: UITableView, canEditRowAt
        indexPath: IndexPath) -> Bool {
        return true
    }

// Als je een cell swiped kan je hem verwijderen. Deze code zorgt ervoor dat de hele to do verwijdert wordt.
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
    

// Segue wordt aangeroepen en checkt of een to do al bestaat en wordt ge-edit of dat er een nieuwe to do wordt aangemaakt.
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as!
        ToDoButtonViewController
        
// Als de to do al bestaat, wordt hij geupdate naar de juiste data.
        if let todo = sourceViewController.todo {
            if let selectedIndexPath =
                tableView.indexPathForSelectedRow {
                todos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath],
                                     with: .none)
// Anders wordt er een nieuwe to do aangemaakt.
            } else {
                let newIndexPath = IndexPath(row: todos.count,
                                             section: 0)
                todos.append(todo)
                tableView.insertRows(at: [newIndexPath],
                                     with: .automatic)
            }
        }
        ToDo.saveToDos(todos)
    }
 
// Code die de informatie van een to do doorgeeft aan het detail scherm als er op een cell wordt gedrukt.
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoViewController = segue.destination
                as! ToDoButtonViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = todos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
        
    }
    
 // Checkt in welke cell de to do zich bevindt om zo de check mark correct aan te passen.
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(todos)
        }
   }
    

}



