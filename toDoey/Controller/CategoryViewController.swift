//
//  CategoryViewController.swift
//  toDoey
//
//  Created by shehab on 8/3/19.
//  Copyright © 2019 shehab. All rights reserved.
//
import CoreData
import UIKit


class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item.name
    
        return cell
    }
    //MARK: - Tablview Delegate Methods
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexpath.row]
            
        }
    }
    
    //MARK: - Data Manipulation Methodss
    
    func saveItems() {
        do{
            try context.save()
        }catch{
            print("error in saving data\(error)")
        }
        tableView.reloadData()
    }
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest() ){
        do{
            categoryArray = try context.fetch(request)
            
        }catch{
            print("error in reading data \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "type new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { (action) in
            let newItem = Category(context: self.context)
            
            newItem.name = textField.text!
            self.categoryArray.append(newItem)
            self.saveItems()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "write category"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   

}
