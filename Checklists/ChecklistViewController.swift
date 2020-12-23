//
//  ViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 23.12.20.
//

import UIKit

class ChecklistViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        // getting the label from our prototype cell with 1000 as its Tag
        let label = cell.viewWithTag(1000) as! UILabel
        
        // setting appropriate value for the row
        let index = indexPath.row % 5
        if index == 0 {
            label.text = "Walk the dog"
        } else if index == 1 {
            label.text = "Brush my teeth"
        } else if index == 2 {
            label.text = "Learn iOS development"
        } else if index == 3 {
            label.text = "Soccer practice"
        } else if index == 4 {
            label.text = "Eat ice cream"
        }
        
        return cell
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            // if cell's accessoryType is .none, set it to .checkmark
            // otherwise, it should be set to .none
            cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        }
        
        // deselect the row so it's not grayed out
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

