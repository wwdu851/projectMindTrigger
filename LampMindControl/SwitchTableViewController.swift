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
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = tabBarSettings().tintColor
//        nav?.titleTextAttributes = tabBarSettings().textColor
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = tabBarSettings().blackcolor
//        self.switchoutlet.backgroundColor = .clear
//        self.switchoutlet.layer.cornerRadius = 5
//        self.switchoutlet.layer.borderWidth = 1
//        self.switchoutlet.layer.borderColor = UIColor.black.cgColor

        
       
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
    }
    
    
    @IBAction func switchUp(_ sender: UIButton) {
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
    
    
    
    



