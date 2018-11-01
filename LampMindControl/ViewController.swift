//
//  ViewController.swift
//  LampMindControl
//
//  Created by William Du on 2016/11/27.
//  Copyright © 2016年 William Du. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController{
    let formater = DateFormatter()
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var text: UILabel!
    
    
    
    func enableProximitySensor (){
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
//            NotificationCenter.default.addObserver(self, selector: #selector(self.proximityChanged(_:)), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device, queue: nil, using: self.proximityChanged)
        }
    }
    
    func proximityChanged(_ notification: Notification) {
        let device = UIDevice.current
        if device.proximityState == true {
            print("Face down")
            NotificationCenter.default.removeObserver(self)
            print("Observer Removed")
            print("Prepared for segue")
            self.scheduleLocalNotification(date: dateConfiguration().config(date: self.datePicker.date))
            disableProximitySensor()
            print("Scheduled")
            self.performSegue(withIdentifier: "newDetailSegue", sender: nil)
        }
    }
    
    func disableProximitySensor () {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = false
        if device.isProximityMonitoringEnabled == false {
            print("Proximity Sensing disabled")
        }
    }
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.enableProximitySensor()
        
       // self.startButton.backgroundColor = tabBarSettings().tintColor
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        datePicker.isHidden = false
        startButton.isHidden = false
        startButton.layer.cornerRadius = 10
        
        
        /*--- Navigation bar settings ---*/
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = tabBarSettings().tintColor
//        nav?.titleTextAttributes = tabBarSettings().textColor
        
        
        self.datePicker?.setValue(UIColor.white, forKeyPath: "textColor")

        

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
    
    @IBAction func unwindToMainMenu(sender:UIStoryboardSegue){
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newDetailSegue"){
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
    
    
    
    @IBAction func changeAlarm(_ sender: UIButton) {

    }
    
    
    @IBAction func enable(_ sender: UIButton) {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
    }
 
    
    


}

