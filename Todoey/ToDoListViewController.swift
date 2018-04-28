//
//  ViewController.swift
//  Todoey
//
//  Created by Mateusz Przybyłowski on 27.04.2018.
//  Copyright © 2018 buikaKRU. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy the Demagorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Tableview style
        self.tableView.separatorStyle = .none

    }

    
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print (itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
       
    }
    
    
    //MARK Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print ("pressed")
            print(textField.text!)
            
            if textField.text! == ""{
                textField.text = "New Item"
            }
            
            self.itemArray.append(textField.text!)
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

