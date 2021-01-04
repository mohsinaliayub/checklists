//
//  Checklist.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 03.01.21.
//

import UIKit

class Checklist: NSObject, Codable {
    var name: String
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
