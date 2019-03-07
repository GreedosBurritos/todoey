//
//  ViewController.swift
//  Todoey
//
//  Created by Joseph Alter on 2/18/19.
//  Copyright © 2019 Joseph Alter. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //--------Constants
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     var lastArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    //MARK: Add Item
    
    @IBAction func addItemButton(_ sender: Any) {
        var item = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //adding an action
            let newCell = Item(context: self.context)
         
            newCell.parentCategory = self.selectedCategory
            newCell.name = item.text!
            newCell.isDone = false
            
            self.lastArray.append(newCell)
            
       self.saveItems()
            
        }
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Create New Item"
         item = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: Save-----------------------------------------------------------------------------------
    
    
    func saveItems(){
       
        do {
            try context.save()
           
        } catch {
           print("error saving stuff\(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
        //MARK: Load-----------------------------------------------------------------------------------
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ) {
    
        let categoryPredicate = NSPredicate(format: "parentCategory.categor MATCHES %@", selectedCategory!.categor!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
       
       
        
        do {
            lastArray = try context.fetch(request)
        }catch{
            print("error is \(error)")
        }
      self.tableView.reloadData()
        
        
    }

     //MARK: Load View-----------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
}
    
        //MARK: Populate Table-----------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let cellObject = lastArray[indexPath.row]
        let cellText = cellObject.name
        let cellIsChecked = cellObject.isDone
        
        cell.accessoryType = cellIsChecked ? .checkmark : .none
        cell.textLabel?.text = cellText
        return cell
    }
    
  
    
    
    
    //MARK: Select Row Done---------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        lastArray[indexPath.row].isDone = !lastArray[indexPath.row].isDone
        
        
  
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
     //MARK: Swipe Row---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            completionHandler(true)
            self.context.delete(self.lastArray[indexPath.row])
            self.lastArray.remove(at: indexPath.row)
            self.saveItems()
        }
        
        let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename, delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
 
    
    

}


   //MARK: - search Bar
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        
       let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
     
        loadItems(with: request, predicate: predicate)
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }        }

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }
          
        }
      
    }
    
}

