//
//  AccountViewController.swift
//  IdaDashboard
//
//  Created by Gunalan Karun on 2/5/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var feedbackTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    let user = "";
    let pass = ""
    
    //MARK: Actions
    @IBAction func login(_ sender: UIButton) {
        if ((usernameTextField.text == user && passwordTextField.text == pass)){
            self.performSegue(withIdentifier: "loginSeg", sender: self)
        } else {
            feedbackTextField.text = "Invalid username or password.";
        }
    }
    @IBAction func createAccount(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createAccountSeg", sender: self)
    }
    
    @IBOutlet weak var createaccount: UIButton!
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
