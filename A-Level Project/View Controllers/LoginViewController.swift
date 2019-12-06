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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func loginButton(_ sender: Any) {

        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
            if error != nil {
                self.createAlert(title: "Login Failed", message: "Invalid email or password")
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
    }
    
    // This function manages the UI for displaying alerts
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

