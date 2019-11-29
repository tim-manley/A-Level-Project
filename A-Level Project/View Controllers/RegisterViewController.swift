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
    @IBOutlet weak var usernameText: UITextField!
    
    let validator = Validator()
    
    
    @IBAction func registerUser(_ sender: Any) {
    
        let newUsername = usernameText.text ?? nil
        let newEmail = emailText.text ?? nil
        let newPassword = passwordText.text ?? nil
        
        
        // The following statements validate each of the inputs returning either an error code,
        // which corresponds to an error in validator.errors, or returning nil, meaning it is valid
        let usernameError = validator.validateUsername(username: newUsername!)
        let emailError = validator.validateEmail(email: newEmail!)
        let passwordError = validator.validatePassword(password: newPassword!)
        
        
        // The following if/else clauses check whether an error was returned during validation and
        // creates appropriate alerts for the user if there is, if there is no error the
        // request is sent through to firebase
        if usernameError != nil {
            createAlert(title: "Invalid username", message: validator.errors[usernameError!]!)
        } else if emailError != nil {
            createAlert(title: "Invalid email", message: validator.errors[emailError!]!)
        } else if passwordError != nil {
            createAlert(title: "Invalid password", message: validator.errors[passwordError!]!)
        } else {
            Auth.auth().createUser(withEmail: newEmail!, password: newPassword!, completion: {(user, error) in
                if error != nil {
                    print(error!)
                }else {
                    print("User registered")
                    db.collection("users").document(Auth.auth().currentUser!.uid).setData([
                        "username": newUsername!
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
    }
    
    
    // This function manages the UI for displaying alerts
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
