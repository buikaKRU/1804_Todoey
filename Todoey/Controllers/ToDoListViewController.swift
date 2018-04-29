//
//  ViewController.swift
//  Todoey
//
//  Created by Mateusz Przybyłowski on 27.04.2018.
//  Copyright © 2018 buikaKRU. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Tableview style
        self.tableView.separatorStyle = .none
        
        
        //Read stored default datea
        
        if let itemchecking = defaults.array(forKey: "ToDoListItemArray") as? [Item] {
            itemArray = itemchecking
        } 

        
        let newItem1 = Item(title: "Find Mike")
        itemArray.append(newItem1)
        
        let newItem2 = Item(title: "Destroy the Demagorgon")
        newItem2.done = true
        newItem2.printNow()
        itemArray.append(newItem2)
        
        
        let newItem3 = Item(title: "save the world!")
        itemArray.append(newItem3)

    }

    
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator =>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
        
    }
    
    
    
    
    
    
    
    //MARK TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row].title)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if itemArray[indexPath.row].done == false {
//           itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.reloadData()
        
        
    }
    
    
    
    
    
    //MARK Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if textField.text! == ""{
                textField.text = "New Item"
            }
            
            let newItem = Item(title: textField.text!)
            newItem.printNow()
            
            //self.defaults.set(self.itemArray, forKey: "ToDoListItemArray")
            
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "ToDoListItemArray")
            self.tableView.reloadData()
        }
        
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        
        
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

