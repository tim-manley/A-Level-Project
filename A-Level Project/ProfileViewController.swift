//
//  ProfileViewController.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 22/03/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import UIKit
import Firebase

let dataBase = Firestore.firestore()

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
