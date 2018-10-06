//
//  FirstViewController.swift
//  mindtrigger
//
//  Created by William Du on 2017/6/22.
//  Copyright © 2017年 William Du. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    let tbvItems = ["Snooze","Sound","Vibration"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tbvItems.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = tbvItems[indexPath.row]
        return cell
    }
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var lowerText: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        mainView.layer.cornerRadius = 15
        mainView.layer.borderWidth = 5
        mainView.layer.borderColor = #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1).cgColor
        mainView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        lowerText.text = timePicker.date.description
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
