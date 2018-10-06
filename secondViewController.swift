//
//  secondViewController.swift
//  mindtrigger
//
//  Created by William Du on 2017/6/22.
//  Copyright © 2017年 William Du. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {
    
    
    @IBOutlet weak var MainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainView.layer.cornerRadius = 15
        MainView.layer.borderWidth = 5
        MainView.layer.borderColor = #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1).cgColor
        MainView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        // Do any additional setup after loading the view.
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

}
