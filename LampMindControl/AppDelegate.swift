//
//  AppDelegate.swift
//  LampMindControl
//
//  Created by William Du on 2016/11/27.
//  Copyright © 2016年 William Du. All rights reserved.
//

import UIKit
import CoreData
import Spark_SDK
import SparkSetup
import AVFoundation
import AudioToolbox
import MediaPlayer
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,AVAudioPlayerDelegate{

    var window: UIWindow?
    var isScreenDown = false
    var AVPlayer:AVAudioPlayer?
    var alarmTriggered = false



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
       
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options:[.alert,.badge,.sound]) { (granted, error) in
            if error != nil{
            
                if granted == true{
                    print("Notification authorization granted")
                }
            }
        }
        
        
        

        return true
    }
    
    /*Proximity sensor functions*/
    
    
    func enableProximitySensor (){
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.proximityChanged(_:)), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "cc.cattail.LampMindControl.startSleeping"{
            let Storyboard = UIStoryboard(name: "main", bundle: nil)
            let destVC = Storyboard.instantiateViewController(withIdentifier:"sleepVC") as! SleepViewController
            self.window?.rootViewController?.present(destVC, animated: true, completion: nil)
        }
    }
    
    func proximityChanged(_ notification: Notification) {
        let device = UIDevice.current
        if device.proximityState == true {
            print("Face down")
            isScreenDown = true
            NotificationCenter.default.post(name: NSNotification.Name("screenIsDown"), object: nil)
            
        }else{
            print("Face up")
            isScreenDown = false
            NotificationCenter.default.post(name: NSNotification.Name("screenIsUp"), object: nil)
        }
        
        
    }
    
    func disableProximitySensor () {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = false
        if device.isProximityMonitoringEnabled == false {
            print("Proximity Sensing disabled")
        }
    }
    
    /*------Proximity Sensor Functions End----------*/

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LampMindControl")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Alarm Triggered!")
        SparkCloud.sharedInstance().getDevices { (sparkDevicesList : [SparkDevice]?, error :Error?) -> Void in
            // 2
            if let sparkDevices = sparkDevicesList
            {
                print(sparkDevices)
                // 3
                for device in sparkDevices
                {
                    if device.name == "parkers_mom"
                    {
                        // 4
                        device.getVariable("moom", completion: { (value,error ) in
                            print("Rip\(value)")
                        }) 
                    }
                }
            }
        }
        alarmTriggered = true
        
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            let url = URL(
                fileURLWithPath: Bundle.main.path(forResource: "Guitar", ofType: "mp3")!)
            print("URL Completed")
            var error:NSError?
            
            do {
                AVPlayer = try AVAudioPlayer(contentsOf: url)
            }catch let error1 as NSError{
                error = error1
                AVPlayer = nil
            }
            
            if let err = error {
                print("Audio Service Error\(err.localizedDescription)")
            } else{
                AVPlayer?.delegate = self
                AVPlayer?.prepareToPlay()
            }
        
            AVPlayer?.numberOfLoops = -1
        
            do {
               try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
                // report for an error
                print("Error Occurs when setting categories")
            }
        
            AVPlayer?.play()
            let volumeView = MPVolumeView()
        if let view = volumeView.subviews.first as? UISlider{
            view.value = 1.0
            print(view.value)
        }
    }
}

