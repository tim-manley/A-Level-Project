//
//  ProfileViewController.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 22/03/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var weightText: UITextField!
    
    @IBAction func updateDB(_ sender: Any) {
        
        db.collection("users").document(Auth.auth().currentUser!.uid).setData([
            "name":nameText.text!,
            "age":Int(ageText.text!)!,
            "weight":Int(weightText.text!)!
            ], merge: true)
        
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        let user = Auth.auth().currentUser
        
        user?.delete {error in
            if let error = error {
                // There was an error
                print("error deleting account", error)
            } else {
                // Account deleted
                print("Account deleted")
            }
        }
        
        db.collection("users").document(user!.uid).delete() { err in
            if let err = err {
                print("error removing document", err)
            } else {
                print("Document successfully removed")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        
        // Add functionality whereby text fields show already existing data
        
        let user = Auth.auth().currentUser
        let usersDocument = db.collection("users").document(user!.uid)
        
        usersDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        
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
