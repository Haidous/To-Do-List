//
//  ViewController.swift
//  To Do List
//
//  Created by Moussa on 7/7/18.
//  Copyright © 2018 Moussa. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    var selectedCategory:Category?{
        
        didSet{
            
            loadItems()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedItem = itemArray[indexPath.row]
        
        selectedItem.isDone = !selectedItem.isDone
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems(){
        
        
        do{try context.save()}catch{}
        
        self.tableView.reloadData();
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        }else{
            
            request.predicate = categoryPredicate
            
        }
        
        do{itemArray = try context.fetch(request)}catch{}
        self.tableView.reloadData();
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add What You Wanna Do!", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let toDoItemText = alertTextField.text {
                
                let newItem = Item(context: self.context)
                newItem.title = toDoItemText
                newItem.isDone = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem);
                
                self.saveItems()
                
            }
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create New Item"
            alertTextField = textField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension ToDoListViewController: UISearchBarDelegate{
    
    //MARK: - Searching Functionality
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: request.predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            DispatchQueue.main.async {searchBar.resignFirstResponder()}
        }
        
    }

}

