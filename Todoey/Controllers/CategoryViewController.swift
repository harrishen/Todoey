//
//  TableViewController.swift
//  Todoey
//
//  Created by Hongyuan Shen on 2/28/19.
//  Copyright © 2019 Hongyuan Shen. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //Only first time of creating Realm can throw errors
    let realm = try! Realm()
    
    var categories: Results<Category>?


    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Category", message: "Create a new category here", preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Sample Category"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

}
