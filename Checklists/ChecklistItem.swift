//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 23.12.20.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked.toggle()
    }
}
