//
//  SleepViewController.swift
//  LampMindControl
//
//  Created by William Du on 2017/2/1.
//  Copyright © 2017年 William Du. All rights reserved.
//

import UIKit
import UserNotifications
import SparkSetup
import Spark_SDK
import MediaPlayer
import HomeKit


class SleepViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let defaults = UserDefaults.standard
    var alarmTime = ""
    var initialWord = ""
    var timer = Timer()
    var progressTimer = Timer()
    var snoozeTimer = Timer()
    let formater = DateFormatter()
    var calendarShowBool = false
    let device = UIDevice.current
    var elapsed = 0.0
    var total = 0.0
    var endTime = Date()
    var startTime = Date()
    var progress = 0.0
    var soundname = "Guitar"
    var snooze = 8
    var vibration = true


    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var sleepDatePicker: UIDatePicker!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var alarmTimeDisplay: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelBtn.layer.cornerRadius = 10
        changeBtn.layer.cornerRadius = 10
        self.sleepDatePicker.isHidden = true
        // Do any additional setup after loading the view.
        self.sleepDatePicker.setValue(UIColor.white, forKey: "textColor")
        self.timeDisplay.text = initialWord
//        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            self.refreshDisplayTime()
//        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.refreshDisplayTime), userInfo: nil, repeats: true)
        self.progressTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.progressValueChange), userInfo: nil, repeats: true)
        self.snoozeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.refreshAlarm), userInfo: nil, repeats: true)
        self.alarmTimeDisplay.text = "Alarm \(alarmTime)"
        total = (dateConfiguration().config(date: endTime).timeIntervalSince(startTime))
        
        switch defaults.integer(forKey: "soundName"){
            case 0:
                soundname = "Guitar"
            case 1:
                soundname = "Ring"
            default:
                break
        }
        
        switch defaults.integer(forKey: "snooze"){
            case 0:
                snooze = 0
            case 1:
                snooze = 60
            case 2:
                snooze = 120
            case 3:
                snooze = 300
            case 4:
                snooze = 480
            case 5:
                snooze = 600
            case 6:
                snooze = 1200
            default:
                break
        }
        
        self.enableProximitySensor()
    }
        

    func enableProximitySensor (){
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(self.proximityChanged(_:)), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        }
    }
    
    func proximityChanged(_ notification: Notification) {
        let device = UIDevice.current
        if device.proximityState == true {
            print("Face down")
            SparkCloud.sharedInstance().getDevices { (sparkDevicesList : [SparkDevice]?, error :Error?) -> Void in
                // 2
                if let sparkDevices = sparkDevicesList
                {
                    print(sparkDevices)
                    // 3
                    for device in sparkDevices
                    {
                        if device.name == "mindTrigger"
                        {
                            // 4
                            device.callFunction("screenIsDown", withArguments: ["down"], completion: { (resultCode,error) -> Void in
                                // 5
                                print("Called screen down function on my device")
                            })
                        }
                    }
                }
            }
        }else if device.proximityState == false{
            print("Face up")
            SparkCloud.sharedInstance().getDevices { (sparkDevicesList : [SparkDevice]?, error :Error?) -> Void in
                // 2
                if let sparkDevices = sparkDevicesList{
                    print(sparkDevices)
                    // 3
                    for device in sparkDevices
                    {
                        if device.name == "mindTrigger"
                        {
                            // 4
                            device.callFunction("screenIsUp", withArguments: ["down"], completion: { (resultCode,error) -> Void in
                                // 5
                                print("Called screen up function on my device")
                            })
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    func disableProximitySensor () {
        NotificationCenter.default.removeObserver(self)
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = false
        if device.isProximityMonitoringEnabled == false {
            print("Proximity Sensing disabled")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func progressValueChange(){
        elapsed = Date().timeIntervalSince(startTime)
        progress = (elapsed/total)
        self.progressBar.progress = Float(progress)
    }
    
    @objc func refreshAlarm(){
        let value = appDelegate.alarmTriggered
        if value == true{
            print("Triggered in vc side")
            self.changeBtn.setTitle("Snooze", for: .normal)
            self.changeBtn.backgroundColor = UIColor.darkGray
            snoozeTimer.invalidate()
            
        }
    }
    
    @objc func refreshDisplayTime(){
        switch NSLocale.current.identifier {
        case "zh_CN":
            formater.dateFormat = "a hh:mm"
        default:
            formater.dateFormat = "hh:mm a"
        }

                timeDisplay.text = formater.string(from: Date())
        
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == ("exitSleepView"){
            let destVC = segue.destination as! ViewController
            destVC.enableProximitySensor()
        }
        
    }
 
    
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        
        
        if (self.sleepDatePicker.isHidden == true){
            self.sleepDatePicker.isHidden = false
            
        }else if (self.sleepDatePicker.isHidden == false){
            switch NSLocale.current.identifier {
            case "zh_CN":
                formater.dateFormat = "a hh:mm"
            default:
                formater.dateFormat = "hh:mm a"
            }
            
            
            usernotification().removenotification()
            usernotification().scheduleLocalNotification(date: dateConfiguration().config(date: sleepDatePicker.date))
            self.alarmTimeDisplay.text = "Alarm \(formater.string(from: sleepDatePicker.date))"
            endTime = dateConfiguration().config(date: sleepDatePicker.date)
            total = endTime.timeIntervalSince(startTime)
            self.sleepDatePicker.isHidden = true
            
            
        }
        
        
    }
    
    @IBAction func cancelBtnLongPressed(_ sender: UILongPressGestureRecognizer) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.AVPlayer?.stop()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("removed")
        timer.invalidate()
        progressTimer.invalidate()
        self.disableProximitySensor()
        SparkCloud.sharedInstance().getDevices { (sparkDevicesList : [SparkDevice]?, error :Error?) -> Void in
            // 2
            if let sparkDevices = sparkDevicesList
            {
                print(sparkDevices)
                // 3
                for device in sparkDevices
                {
                    if device.name == "mindTrigger"
                    {
                        // 4
                        device.callFunction("alarmClose", withArguments: ["alarmClose"], completion: { (resultCode,error) -> Void in
                            // 5
                            print("Called Alarm Close Function")
                        })
                    }
                }
            }
        }
        self.performSegue(withIdentifier: "exitSleepView", sender: nil)
        delegate.alarmTriggered = false
        
    }

    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.cancelBtn.setTitle("HOLD To Cancel Alarm", for: .normal)
        
    }
    
    

}
