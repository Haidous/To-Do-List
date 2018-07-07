//
//  CategoryViewController.swift
//  To Do List
//
//  Created by Moussa on 7/7/18.
//  Copyright © 2018 Moussa. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
        
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func saveCategories(){
        
        do{try context.save()}catch{}
        
        self.tableView.reloadData();
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{categoryArray = try context.fetch(request)}catch{}
        self.tableView.reloadData();
        
    }

    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add A Category!", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if let categoryText = alertTextField.text {
                
                let newCategory = Category(context: self.context)
                newCategory.name = categoryText
                
                self.categoryArray.append(newCategory);
                
                self.saveCategories()
                
            }
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create New Category"
            alertTextField = textField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
