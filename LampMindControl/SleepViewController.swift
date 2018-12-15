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
        
        self.enableProximitySensor(enabled: true)
    }
    
    func sendParticleData(screenOn: Bool) {
        SparkCloud.sharedInstance().getDevices { (sparkDevicesList : [SparkDevice]?, error :Error?) -> Void in
            // 2
            if let sparkDevices = sparkDevicesList{
                print(sparkDevices)
                for device in sparkDevices
                {
                    if device.name == "01"
                    {
                        if screenOn == true{
                            device.callFunction("screenOn", withArguments: ["down"], completion: { (resultCode,error) -> Void in
                                print("Screen On Function Called")
                            })
                        }else{
                            device.callFunction("screenOff", withArguments: ["down"], completion: { (resultCode,error) -> Void in
                                print("Screen Off Function Called")
                            })
                        }
                        
                    }
                }
            }
        }
    }
        

    func enableProximitySensor(enabled: Bool) {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = enabled
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: .UIDeviceProximityStateDidChange, object: device)
        } else {
            NotificationCenter.default.removeObserver(self, name: .UIDeviceProximityStateDidChange, object: nil)
        }
    }
    
    @objc func proximityChanged(_ notification: Notification) {
        if let device = notification.object as? UIDevice {
            if device.proximityState == true {
                sendParticleData(screenOn: false)
            }else{
                sendParticleData(screenOn: true)
            }
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
        self.enableProximitySensor(enabled: false)
        delegate.alarmTriggered = false
        SparkCloud.sharedInstance().getDevices { (sparkDevicesList : [SparkDevice]?, error :Error?) -> Void in
            // 2
            if let sparkDevices = sparkDevicesList{
                print(sparkDevices)
                for device in sparkDevices
                {
                    if device.name == "01"
                    {
                        device.callFunction("sleepModeOff", withArguments: ["down"], completion: { (resultCode,error) -> Void in
                            print("Sleep Mode Turned Off")
                        })
                    }
                }
            }
        }
        self.performSegue(withIdentifier: "exitToMainScreen", sender: nil)
        
    }

    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.cancelBtn.setTitle("HOLD TO CANCEL ALARM", for: .normal)
    }
    
    

}
