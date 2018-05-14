//
//  ViewController.swift
//  Todoey
//
//  Created by Mateusz Przybyłowski on 27.04.2018.
//  Copyright © 2018 buikaKRU. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var toDoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        
        //didSet getsfired when selectedCategory variable gets a value
        didSet{
            
            //Read stored default data
            loadItems()
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Tableview style
        self.tableView.separatorStyle = .none
        


    }

    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //as! CustomItemCell
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = toDoItems?[indexPath.row].title
            
            // Ternary operator =>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added Yet"
            cell.accessoryType = .none
        }
        
        
        
        
        return cell
        
    }
    
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(toDoItems?[indexPath.row].title ?? "none")
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error writing data - \(error)")
            }
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if textField.text! == ""{
                textField.text = "New Item"
            }
        
            
            if let currentCategory = self.selectedCategory {
               
                do {
                    try self.realm.write {
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        //newItem.done = false
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                    
                } catch {
                    
                }
    
            }
            
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
    
    
    
    
    //MARK: - Model Manipulation methods
    
    
    
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    func refreshSearch(searchText: String = ""){
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
        print(searchText)
        
        tableView.reloadData()
        
    }
    
    
}






//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked!! \(searchBar.text!)")
        
        refreshSearch(searchText: searchBar.text!)

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("aktualny search bar: \(searchBar.text ?? "")")
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            
            
            //unselecting searchbar
            
            DispatchQueue.main.async{
               searchBar.resignFirstResponder()
            }
            
            
        } else {
            refreshSearch(searchText: searchBar.text!)
        }
    }
}


