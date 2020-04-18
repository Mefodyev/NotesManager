//
//  Notifications.swift
//  Notes Manager
//
//  Created by Alexey Mefodyev on 13.04.2020.
//  Copyright © 2020 LexMefodyev. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {

    let notificationsCenter = UNUserNotificationCenter.current()
    
    func authorizeForNotifications() {
        notificationsCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (accessed, error) in
            print("User \(accessed) receiving notifications")
        }
    }
    

    
    func scheduleHourNotification(notificationType: String, time0fTask: Date) {
                
        let content = UNMutableNotificationContent()
        
        content.title = notificationType
        content.body = "Задача " + notificationType + " начнется через час"
        content.sound = .default
        content.badge = 1
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        let timeOfNotification = time0fTask.addingTimeInterval(-3600)
        let hour = calendar.component(.hour, from: timeOfNotification)
        let minute = calendar.component(.minute, from: timeOfNotification)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let identifier = "Уже через час"
        
//        let url = Data.self
//        let uuu = 
//        let attachment = UNNotificationAttachment(identifier: "", url: url, options: nil)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationsCenter.add(request) { (error) in
            if let error = error {
                print("\(error.localizedDescription) with hour notification")
            }
        }
    }
    
    //чтоб уведомления приходили когда приложение активно, на переднем экране
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler ([.alert, .sound])
    }
    
}
