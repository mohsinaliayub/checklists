//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 03.01.21.
//

import UIKit

class AllListsViewController: UITableViewController, UINavigationControllerDelegate, ListDetailViewControllerDelegate {
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register a reuse identifier for UITableViewCell in our table view
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set AllListsViewController as delegate for UINavigationController
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }

    // MARK: - Table view Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let cell: UITableViewCell!
        if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let checklist = dataModel.lists[indexPath.row]

        cell.textLabel?.text = checklist.name
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell?.detailTextLabel?.text = "(No Items)"
        } else {
            cell.detailTextLabel?.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        cell.imageView?.image = UIImage(named: checklist.iconName)
        cell.accessoryType = .detailDisclosureButton

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    // MARK:- Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // save the checklist index to UserDefaults
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    // instantiate view controller from storyboard, set the delegate and checklist properties, and push
    // that view controller on top using navigation controller
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as? ListDetailViewController {
            controller.delegate = self
            
            let checklist = dataModel.lists[indexPath.row]
            controller.checklistToEdit = checklist
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    // MARK:- Navigation Controller Delegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        // Was the back button tapped?
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    // MARK:- List Detail View Controller Delegate
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }

}
