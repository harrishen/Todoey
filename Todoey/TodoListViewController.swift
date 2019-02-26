//
//  ViewController.swift
//  Todoey
//
//  Created by Hongyuan Shen on 2/25/19.
//  Copyright © 2019 Hongyuan Shen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["First", "Second", "Third"]
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoItemArray") as? [String] {
            itemArray = items
        }
        
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
            self.itemArray.append(tf.text!)
            self.defaults.set(self.itemArray, forKey: "TodoItemArray")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK - TabelView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        let currentCell = tableView.cellForRow(at: indexPath)
        if currentCell?.accessoryType == .checkmark {
            currentCell?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

