//
//  DashboardViewController.swift
//  IdaDashboard
//
//  Created by Gunalan Karun on 2/5/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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

    // MARK: - UI Actions
    @IBAction func startTrip(_ sender: UIButton) {
        performSegue(withIdentifier: "toActiveTrip", sender: self)
    }
    
    @IBAction func tripEnded(_ sender: UIStoryboardSegue) {
        
    }
}
