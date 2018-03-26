//
//  CreateAccountViewController.swift
//  IdaDashboard
//
//  Created by Kalhan Koul on 2/24/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    
    //MARK: Properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: Actions
    @IBAction func createAccount(_ sender: UIButton) {
                self.performSegue(withIdentifier: "createAccountLoginSeg", sender: self)
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
