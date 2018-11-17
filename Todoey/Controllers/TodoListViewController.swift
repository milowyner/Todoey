//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Milo Wyner on 10/16/18.
//  Copyright © 2018 Milo Wyner. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    var itemArray: Results<Item>!
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.title = selectedCategory?.name
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
        
        do {
            let realm = try Realm()
            try realm.write {
                itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            }
        }
        catch {
            print("Error updating done property to realm")
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let textField = alert.textFields![0]
            if textField.text != "" {
                
                let newItem = Item()
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory

                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(newItem)
                    }
                }
                catch {
                    print("Error saving item, \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //MARK - Load items
    
    func loadItems(using predicate: NSPredicate? = nil) {
        var categoryPredicate = NSPredicate(format: "parentCategory.name == %@", selectedCategory!.name)
        
        if let additionalPredicate = predicate {
            categoryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        
        do {
            let realm = try Realm()
            itemArray = realm.objects(Item.self).filter(categoryPredicate)
        }
        catch {
            print("Error initializing Realm, \(error)")
        }
        
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadItems()
        }
        else {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            loadItems(using: predicate)
        }
    }
    
}

