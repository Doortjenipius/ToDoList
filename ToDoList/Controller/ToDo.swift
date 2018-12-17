//
//  ToDo.swift
//  ToDoList
//
//  Created by doortje on 27/11/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import Foundation

// Codabel struct, zodat er mee gewerkt kan worden.
struct ToDo: Codable {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    // Sample data om ToDo te testen, wordt niet gebruikt. Je kan je eigen data in de app toevoegen.
    static func loadSampleToDos() -> [ToDo] {
        let todo1 = ToDo(title: "ToDo 1", isComplete: false,
                         dueDate: Date(), notes: "Leuk bericht")
        let todo2 = ToDo(title: "ToDo 2", isComplete: false,
                         dueDate: Date(), notes: "Komt goed")
        let todo3 = ToDo(title: "ToDo 3", isComplete: false,
                         dueDate: Date(), notes: "Oh shit")
        
        return [todo1, todo2, todo3]
    }
    
    // Haalt de juiste data op uit het pad.
    static func loadToDos() -> [ToDo]?  {
        guard let codedToDos = try? Data(contentsOf: ArchiveURL)
            else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self,
                                               from: codedToDos)
    }
    // Date picker formatter. Deze geeft aan dat de stijl van de datum en tijd kort is. 
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    // Defineert een pad waar de data wordt opgeslagen.
    static let DocumentsDirectory =
        FileManager.default.urls(for: .documentDirectory,
                                 in: .userDomainMask).first!
    static let ArchiveURL =
        DocumentsDirectory.appendingPathComponent("todos")
            .appendingPathExtension("plist")
    
    // Slaat de juiste data op op de correcte plaats. 
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ArchiveURL,
                               options: .noFileProtection)
    }
    
    
}
