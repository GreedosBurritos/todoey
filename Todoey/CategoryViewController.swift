//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joseph Alter on 3/6/19.
//  Copyright © 2019 Joseph Alter. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //MARK: variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     var categoryArray = [Category]()
    
    
    //MARK: Load View-----------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
          loadItems()      }
    
    
    
   
    //MARK: Load-----------------------------------------------------------------------------------
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        
        do {
            categoryArray = try context.fetch(request)
        } catch{
            print("error is \(error)")
        }
        self.tableView.reloadData()
        
        
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
   
    
    //MARK: Load View-----------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let cellObject = categoryArray[indexPath.row]
        let cellText = cellObject.categor
        
            
        cell.textLabel?.text = cellText
        return cell
    }
    //MARK: add item Row Done---------------------------------------------------------------------------------
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var item = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //adding an action
            let newCell = Category(context: self.context)
            newCell.categor = item.text!
            
            self.categoryArray.append(newCell)
            
            self.saveItems()
            
        }
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Create New Category"
            item = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Select Row Done---------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       performSegue(withIdentifier: "goToItems", sender: self)
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
   

    
    
}
