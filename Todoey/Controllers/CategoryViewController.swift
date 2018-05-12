//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mateusz Przybyłowski on 11.05.2018.
//  Copyright © 2018 buikaKRU. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categoryArray = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask )
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("dat file pathis: \(dataFilePath)")
        
        //Tableview style
        self.tableView.separatorStyle = .none
        
        loadCategory()

    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
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
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text
            newCategory.dateCreated = Date()
            newCategory.finished = false
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
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
    
    func saveCategory(){
        do{
            try context.save()
        } catch {
            print("error saving to database: \(error)")
        }
        
        tableView.reloadData()
    }
    

    func loadCategory(){
        do{
            try categoryArray = try context.fetch(Category.fetchRequest())
        } catch {
            print("error fetching: \(error)")
        }
        
        tableView.reloadData()

    }
    
    
    
    
     //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print("********************************************** \(categoryArray[indexPath.row].name!)")
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
}
