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
        
        theUser.document.setData([
            "name":nameText.text ?? ""
            ], merge: true)
        theUser.document.setData([
            "age":Int(ageText.text ?? "0")
            ], merge: true)
        theUser.document.setData([
            "weight":Int(weightText.text ?? "0")
            ], merge: true)
        
        theUser.name = nameText.text
        theUser.age = ageText.text
        theUser.weight = weightText.text
        
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        let user = theUser.user
        
        user?.delete {error in
            if let error = error {
                // There was an error
                print("error deleting account", error)
            } else {
                // Account deleted
                print("Account deleted")
            }
        }
        
        theUser.document.delete() { err in
            if let err = err {
                print("error removing document", err)
            } else {
                print("Document successfully removed")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        // set default values for the text fields
        if let name: String = theUser!.name as? String {
            if name == "<null>" {
                nameText.text = nil
            } else {
                nameText.text = ("\(name)")
            }
        }
        if let age = theUser.age {
            ageText.text = ("\(age)")
        }
        if let weight = theUser.weight {
            weightText.text = ("\(weight)")
        }
        
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
