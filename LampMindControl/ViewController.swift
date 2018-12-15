//
//  ViewController.swift
//  LampMindControl
//
//  Created by William Du on 2016/11/27.
//  Copyright © 2016年 William Du. All rights reserved.
//

import UIKit
import Spark_SDK
import SparkSetup
import UserNotifications

class ViewController: UIViewController{
    let formater = DateFormatter()
    
    
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKey: "textColor")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scheduleLocalNotification(date:Date){
        let notification = UNMutableNotificationContent()
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let dateComponent = calendar?.components([.day,.hour,.minute], from: date)
        notification.title = "Hello"
        notification.body = "It's time to get up"
        notification.sound = UNNotificationSound.init(named: "ngt.aif")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent!, repeats: false)
        let request = UNNotificationRequest(identifier: "wakeUpNotification", content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error == nil{
                print("Successfully scheduled notification for \(date)")
            }
        }
        
    }
    
    @IBAction func unwindToMainViewController(_ sender:UIStoryboardSegue) { }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.scheduleLocalNotification(date: dateConfiguration().config(date: self.datePicker.date))
        SparkCloud.sharedInstance().getDevices { (sparkDevicesList : [SparkDevice]?, error :Error?) -> Void in
            // 2
            if let sparkDevices = sparkDevicesList{
                print(sparkDevices)
                for device in sparkDevices
                {
                    if device.name == "01"
                    {
                        device.callFunction("sleepModeOn", withArguments: ["down"], completion: { (resultCode,error) -> Void in
                            print("Sleep Mode On")
                        })
                    }
                }
            }
        }
        if (segue.identifier == "showSleepViewSegue"){
            if let destVC = segue.destination as? SleepViewController{
                switch NSLocale.current.identifier {
                case "zh_CN":
                    formater.dateFormat = "a hh:mm"
                default:
                    formater.dateFormat = "hh:mm a"
                }
                destVC.initialWord = formater.string(from: Date())
                destVC.alarmTime = formater.string(from: datePicker.date)
                destVC.endTime = self.datePicker.date
                destVC.startTime = Date()
            }
            
            
            
    
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    

}

