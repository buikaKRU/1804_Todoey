//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mateusz Przybyłowski on 11.05.2018.
//  Copyright © 2018 buikaKRU. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask )

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Tableview style
        self.tableView.separatorStyle = .none
        
        loadCategory()
        
        tableView.rowHeight = 80.0
    

    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.delegate = self
        
        return cell
        
    }
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        
        let action = UIAlertAction(title: "Add New Category", style: .default) { (action) in
            
            if textField.text! == ""{
                textField.text = "New Category"
            }
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.dateCreated = Date()
            newCategory.finished = false
            
            self.saveCategory(category: newCategory)
            
            self.tableView.reloadData()
            
        }
        
        
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "New Category"
            textField = alertTextFiled
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving to database: \(error)")
        }
        
        tableView.reloadData()
    }
    

    func loadCategory(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()

    }
    
    
    
    
     //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
}





//MARK: - Swipe Cell Delegate Methods

extension CategoryViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item Deleted")
            
            print("item # \(indexPath.row)")
            print(self.categories?[indexPath.row].name)
            
            
            if let itemToDelete = self.categories?[indexPath.row] {
                try! self.realm.write {
                    self.realm.delete(itemToDelete)
                }
                
                
            }
        }
        

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
