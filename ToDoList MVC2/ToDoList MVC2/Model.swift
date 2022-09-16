//
//  Model.swift
//  ToDoList MVC2
//
//  Created by Тимур Гарипов on 13.09.22.
//

import Foundation
import UIKit



class Item {
    var taskName: String
    var completed: Bool
    
    init(string: String, completed: Bool) {
        self.taskName = string
        self.completed = completed
    }
}

class Model {
    
    var editButtonClicked: Bool = false
    var toDoItemFiltered = [Item]()
    
    var toDoItems: [Item] = [
        Item(string: "Codding at 9 am", completed: false),
        Item(string: "SkillFacktory- Home Work", completed: true),
        Item(string: "Sanset at 6 pm", completed: false),
                            ]
    
    func addNewTask(itemName: String, isCompleted: Bool = false){
        toDoItems.append(Item(string: itemName, completed: isCompleted))
    }
    
    func removeItem(indexPath: IndexPath) {
        toDoItems.remove(at: indexPath.row)
    }
    
    func updateItem(at index: Int, with string: String) {
        toDoItems[index].taskName = string
    }
   
// Метод фильтации для строки поиска
    func filterToDoItems(taskName: String){
        toDoItemFiltered.removeAll()
        
        toDoItemFiltered = toDoItems.filter({ (item) -> Bool in
            return item.taskName.lowercased().contains(taskName.lowercased())
        })

    }
}
