//
//  SwitchTableViewController.swift
//  LampMindControl
//
//  Created by William Du on 2016/12/2.
//  Copyright © 2016年 William Du. All rights reserved.
//

import UIKit
import AVFoundation
import Spark_SDK
import SparkSetup
import CoreData


var lightLogic = true

class SwitchTableViewController: UITableViewController{
    
    
    
    @IBOutlet weak var switchoutlet: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        nav?.barTintColor = tabBarSettings().tintColor
//        nav?.titleTextAttributes = tabBarSettings().textColor
        
        self.tableView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        self.tableView.tableFooterView = UIView()

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func Switch(_ sender: Any) {
        SparkCloud.sharedInstance().getDevices { (sparkDevicesList : [SparkDevice]?, error :Error?) -> Void in
            // 2
            if let sparkDevices = sparkDevicesList
            {
                print(sparkDevices)
                // 3
                for device in sparkDevices
                {
                    if device.name == "01"
                    {
                        // 4
                        device.callFunction("turnOnAll", withArguments: ["down"], completion: { (resultCode,error) -> Void in
                            // 5
                            print("Turn On All Function Called")
                        })
                    }
                }
            }
        }
    }
    
    
    @IBAction func switchUp(_ sender: UIButton) {
        SparkCloud.sharedInstance().getDevices { (sparkDevicesList : [SparkDevice]?, error :Error?) -> Void in
            // 2
            if let sparkDevices = sparkDevicesList{
                print(sparkDevices)
                // 3
                for device in sparkDevices
                {
                    if device.name == "01"
                    {
                        // 4
                        device.callFunction("turnOffAll", withArguments: ["down"], completion: { (resultCode,error) -> Void in
                            // 5
                            print("Turn Off All Function Called")
                        })
                    }
                }
            }
        }
    }
}
    
    
    
    



