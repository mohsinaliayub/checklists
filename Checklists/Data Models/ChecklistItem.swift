//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 23.12.20.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID
    }
    
    func toggleChecked() {
        checked.toggle()
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            // create notification content
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = self.text
            content.sound = UNNotificationSound.default
            
            // create components of our dueDate (like year, month, day, hour, minute)
            // to show notification at that time
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.dueDate)
            
            // create a trigger for sending notification
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // create notification request
            let request = UNNotificationRequest(identifier: String(self.itemID),
                                                content: content,
                                                trigger: trigger)
            
            // add our request to notification center
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(self.itemID)"])
    }
    
    deinit {
        removeNotification()
    }
}
