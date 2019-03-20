//
//  RegisterViewController.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 01/03/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func registerUser(_ sender: Any) { // NOT WORKING YET (SAYS USER IS REGISTERED, DOESN'T SHOW ON FIREBASE)
        
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: {(user, error) in
            if error != nil {
                print(error!)
            }else {
                print("User registered")
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
