//
//  Checklist.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 03.01.21.
//

import UIKit

class Checklist: NSObject, Codable {
    var name: String
    var iconName: String
    var items = [ChecklistItem]()
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        let uncheckedItems = items.filter { !$0.checked }
        return uncheckedItems.count
    }
}
