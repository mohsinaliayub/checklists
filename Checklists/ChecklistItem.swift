//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 23.12.20.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked.toggle()
    }
}
