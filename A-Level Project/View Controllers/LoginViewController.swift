//
//  ViewController.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 30/01/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField! 
    @IBOutlet weak var passwordText: UITextField!
    
    let adaptor = FirebaseAdaptor()
    
    @IBAction func loginButton(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
            if error != nil {
                // show alert
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

