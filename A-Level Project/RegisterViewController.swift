//
//  RegisterViewController.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 01/03/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

let db = Firestore.firestore()

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
    @IBAction func registerUser(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: {(user, error) in
            if error != nil {
                print(error!)
            }else {
                let theUser = self.nameText.text!
                print("User registered")
                db.collection("users").document(Auth.auth().currentUser!.uid).setData([
                    "name": theUser
                    ]){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(Auth.auth().currentUser!.uid)")
                    }
                }
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
