//
//  notificationConfiguration.swift
//  LampMindControl
//
//  Created by William Du on 2017/2/26.
//  Copyright © 2017年 William Du. All rights reserved.
//

import Foundation
import UserNotifications


struct usernotification{
    func scheduleLocalNotification(date:Date){
        let notification = UNMutableNotificationContent()
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let dateComponent = calendar?.components([.day,.hour,.minute], from: date)
        notification.title = "Hello"
        notification.body = "It's time to get up"
        notification.sound = UNNotificationSound.init(named: "Guitar")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent!, repeats: false)
        let request = UNNotificationRequest(identifier: "wakeUpNotification", content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error == nil{
                print("Successfully scheduled notification for \(date)")
            }
        }
        
    }
    
    
    func removenotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}
  
