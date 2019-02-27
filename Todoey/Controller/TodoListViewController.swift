//
//  ViewController.swift
//  Todoey
//
//  Created by Hongyuan Shen on 2/25/19.
//  Copyright © 2019 Hongyuan Shen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        let item1 = Item()
        let item2 = Item()
        let item3 = Item()
        
        item1.title = "Item1"
        item2.title = "Item2"
        item3.title = "Item3"
        
        itemArray.append(item1)
        itemArray.append(item2)
        itemArray.append(item3)
        
        if let items = defaults.array(forKey: "TodoItemArray") as? [Item] {
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
            let newItem = Item()
            newItem.title = tf.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoItemArray")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.finished ? .checkmark : .none
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK - TabelView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.itemArray[indexPath.row].finished = !self.itemArray[indexPath.row].finished
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

