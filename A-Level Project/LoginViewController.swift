//
//  ViewController.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 30/01/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField! 
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: {(user, error) in
            if error != nil{
                print(error!)
            }else{
                print("login successful")
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

