//
//  ProximityDetect.swift
//  LampMindControl
//
//  Created by William Du on 2017/2/1.
//  Copyright © 2017年 William Du. All rights reserved.
//

import UIKit

//var isScreenDown = false
//
//struct proximityDetect {
//    func enableProximitySensor (){
//        let device = UIDevice.current
//        device.isProximityMonitoringEnabled = true
//        if device.isProximityMonitoringEnabled {
//            NotificationCenter.default.addObserver(self, selector: #selector(self.proximityChanged(_:)), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
//        }
//    }
//    
//    func proximityChanged(_ notification: Notification) {
//        let device = UIDevice.current
//        if device.proximityState == true {
//            print("Face down")
//            isScreenDown = true
//            
//        }else{
//            print("Face up")
//            isScreenDown = false
//        }
//        
//        
//    }
//    
//    func disableProximitySensor () {
//        let device = UIDevice.current
//        device.isProximityMonitoringEnabled = false
//        if device.isProximityMonitoringEnabled == false {
//            print("Proximity Sensing disabled")
//        }
//    }
//}
