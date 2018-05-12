//
//  ViewController.swift
//  Todoey
//
//  Created by Mateusz Przybyłowski on 27.04.2018.
//  Copyright © 2018 buikaKRU. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        
        //didSet getsfired when selectedCategory variable gets a value
        didSet{
            
            //Read stored default data
            loadItems()
            
            
        }
    }
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask )
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let request : NSFetchRequest<Item> = Item.fetchRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath)
        
        //Tableview style
        self.tableView.separatorStyle = .none
        
        

        
        //tableView.register(UINib(nibName: "CustomItemCell", bundle: nil), forCellReuseIdentifier: "customItemCell")
        


    }

    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //as! CustomItemCell
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator =>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
        
    }
    
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row].title!)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
        
    }
    
    
    
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if textField.text! == ""{
                textField.text = "New Item"
            }
        
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text
      
            newItem.dateCreated = Date()
            
            newItem.parentCategory = self.selectedCategory
            
            
            self.itemArray.append(newItem)
            
            self.saveItem()
            
            
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
    
    func saveItem(){
        
        do {
            try context.save()
        } catch {
            print("Error encoding data \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name CONTAINS[cd] %@", (selectedCategory?.name)!)
        
        //let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        //request.predicate = compoundPredicate
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error decoding items array: \(error)")
        }
        
        tableView.reloadData()
    
    }
    
    func refreshSearch(searchText: String = ""){
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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

