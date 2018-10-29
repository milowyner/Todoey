//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Milo Wyner on 10/16/18.
//  Copyright © 2018 Milo Wyner. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [Item] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if defaults.array(forKey: "letArray") != nil {
//            defaults.set(itemArray, forKey: "itemArray")
//        }
//        if let items = defaults.array(forKey: "itemArray") as? [Item] {
//            itemArray = items
//        }
    }

    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            itemArray[indexPath.row].done = false
            cell?.accessoryType = .none
        }
        else {
            itemArray[indexPath.row].done = true
            cell?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let textField = alert.textFields![0]
            if textField.text != "" {
                self.itemArray.append(Item(name: textField.text!))
                //self.defaults.set(self.itemArray, forKey: "itemArray")
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

