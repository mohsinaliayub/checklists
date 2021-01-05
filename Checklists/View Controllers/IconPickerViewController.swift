//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 05.01.21.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ controller: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    
    weak var delegate: IconPickerViewControllerDelegate?
    let icons = [ "No Icon", "Appointments", "Birthdays", "Chores",
                  "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips" ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)

        let iconName = icons[indexPath.row]
        cell.textLabel?.text = iconName
        cell.imageView?.image = UIImage(named: iconName)

        return cell
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }

}
