//
//  ViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 23.12.20.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var items = [ChecklistItem]()
    var checklist: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting title
        self.title = checklist.name
        
        // loading data from .plist file
        loadChecklistItems()
    }
    
    // get label from prototype cell, and set its text property
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // sets the checkmark based on item's checked property
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = item.checked ? "√" : ""
    }
    
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)

        // getting the item at index, and displaying it using cell
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            
            configureCheckmark(for: cell, with: item)
        }
        
        // deselect the row so it's not grayed out
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // remove the item from data model, i.e. items array
        // then remove it from tableView to keep them in sync
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveChecklistItems()
    }
    
    // MARK:- Add Item View Controller Delegate
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    // get index of new item which will be added to array, append item to array
    // insert that item into tableView
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    
    // find the index of edited item in items array, create a new IndexPath object
    // find the cell that contains the item, and update existing text
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            // setting up the delegate
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            // getting the indexPath of item that was selected
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    // MARK:- Data Persistence
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding items array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                items = try decoder.decode([ChecklistItem].self, from: data)
                
            } catch {
                print("Error decoding items array: \(error.localizedDescription)")
            }
        }
        
    }
    
}

