//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Milo Wyner on 11/6/18.
//  Copyright © 2018 Milo Wyner. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    var categoryArray: Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create new todo list controller
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories() {
        tableView.reloadData()
    }
    
    func loadCategories() {
        do {
            let realm = try Realm()
            categoryArray = realm.objects(Category.self)
        }
        catch {
            print("Error initializing Realm, \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create new category"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0]
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(newCategory)
                    }
                }
                catch {
                    print("Error writing to Realm database, \(error)")
                }
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
}
