//
//  ViewController.swift
//  Todoey
//
//  Created by Hongyuan Shen on 2/25/19.
//  Copyright © 2019 Hongyuan Shen. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadData()
    
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create new item", message: "", preferredStyle: .alert)

        var tf = UITextField()

        alert.addTextField { (alertTF) in
            alertTF.placeholder = "New item name"
            tf = alertTF
        }

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = tf.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Context Saving Error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.finished ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return todoItems?.count ?? 1
    }

    //MARK: - TabelView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.finished = !item.finished
                }
            } catch {
                print("Error saving items: \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
