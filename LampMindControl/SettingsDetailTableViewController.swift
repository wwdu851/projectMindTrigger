//
//  SettingsDetailTableViewController.swift
//  LampMindControl
//
//  Created by William Du on 2017/2/11.
//  Copyright © 2017年 William Du. All rights reserved.
//

import UIKit
import Spark_SDK
import SparkSetup
import CoreData

class SettingsDetailTableViewController: UITableViewController {
    
    
    let userdefault = UserDefaults.standard
    var currentTableType = ""
    var rowValue = 0
    var sectionValue = 0
    var numberOfRows = 0
    var numberOfSections = 0
    let booleanTypeValue = ["On","Off"]
    let snoozeTypeValue = ["None","1 Minutes","2 Minutes","5 Minutes","8 Minutes","10 Minutes","20 Minutes"]
    let soundTypeValue = ["Guitar","Ring"]
    var currentTypeValue:[String] = []
    @IBOutlet weak var mattressPadConnect: UIButton!
    @IBOutlet weak var buttonBackgroundUIView: UIView!
    
    let optionSelectedFromPreviousTableView = ["Snooze","Sound","Vibration","Trigger","Mattress"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = optionSelectedFromPreviousTableView[rowValue]
        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.titleTextAttributes = tabBarSettings().textColor
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//
        mattressPadConnect.layer.cornerRadius = 5
        if sectionValue == 0{
            mattressPadConnect.isHidden = true
            buttonBackgroundUIView.isHidden = true
            numberOfSections = 1
            switch rowValue {
            case 0:
                currentTypeValue = snoozeTypeValue
                currentTableType = "snooze"
            case 1:
                currentTypeValue = soundTypeValue
                currentTableType = "sound"
            case 2:
                currentTypeValue = booleanTypeValue
                currentTableType = "vibration"
            default:
                break
            }
            numberOfRows = currentTypeValue.count
        }
        print(rowValue)
        print(sectionValue)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        print(indexPath)
        cell.textLabel?.text = currentTypeValue[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        switch currentTableType {
            case "snooze":
                saveSnoozeTime(integer: indexPath[1])
                print(indexPath[1])
            case "sound":
                saveSoundName(integer: indexPath[1])
                print(indexPath[1])
            case "vibration":
                if indexPath[1] == 0{
                    saveVibrationBool(bool: false)
                }else{
                    saveVibrationBool(bool: true)
                }
            default:
                print("default")
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    func saveSnoozeTime(integer:Int){
        userdefault.set(integer, forKey: "snooze")
    }
    
    func saveVibrationBool(bool:Bool){
        userdefault.set(bool, forKey: "vibration")
    }
    
    func saveSoundName(integer:Int){
        userdefault.set(integer, forKey: "soundName")
    }
   
    @IBAction func Connect(_ sender: UIButton) {
        let setupController = SparkSetupMainController()
        self.present(setupController!, animated: true, completion: nil)
    }
    

}
