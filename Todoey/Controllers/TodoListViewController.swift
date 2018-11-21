//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Milo Wyner on 10/16/18.
//  Copyright © 2018 Milo Wyner. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation bar does not exist")}

        guard let colorHex = selectedCategory?.color else {fatalError()}
        guard let color = UIColor(hexString: colorHex) else {fatalError()}
        
        searchBar.barTintColor = color
        navBar.barTintColor = color
        navBar.tintColor = ContrastColorOf(color, returnFlat: true)
        navBar.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(color, returnFlat: true)]
        
        // Removes border around search bar
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = color.cgColor
        
        title = selectedCategory!.name
    }

    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count) / 2) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating done property to realm")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let textField = alert.textFields![0]
            if textField.text != "" {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.color = UIColor.randomFlat.hexValue()
                            
                            currentCategory.items.append(newItem)
                        }
                    }
                    catch {
                        print("Error saving item, \(error)")
                    }
                }
                
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //MARK: - Load items
    
    func loadItems() {
        todoItems = selectedCategory?.items.filter("TRUEPREDICATE")
        tableView.reloadData()
    }
    
    //MARK: - Delete Item From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
}

//MARK: - Search

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
            if let currentItems = todoItems {
                todoItems = currentItems.filter("title CONTAINS[cd] %@", searchBar.text!)
                tableView.reloadData()
            }
        }
    }
    
}

