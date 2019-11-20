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
    @IBOutlet weak var targetGlucoseText: UITextField!
    @IBOutlet weak var correctionFactorText: UITextField!
    
    let adaptor = FirebaseAdaptor()
    var uid: String? = nil
    var user: User? = nil
    
    @IBAction func save(_ sender: Any) {
        // set all the values for the user object
        user!.name = nameText.text
        user!.age = Int(ageText.text!) ?? nil
        user!.weight = Float(weightText.text!) ?? nil
        user!.targetGlucose = Float(targetGlucoseText.text!) ?? nil
        user!.correctionFactor = Int(correctionFactorText.text!) ?? nil
        
        // call the update firebase function from the adaptor
        // and use the new user object to inform the update
        adaptor.updateUser(user: user!)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        
        
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        adaptor.getUser(uid: uid!) { user in
            self.user = user
            self.nameText.text = self.user!.name?.description
            self.ageText.text = self.user!.age?.description
            self.weightText.text = self.user!.weight?.description
            self.targetGlucoseText.text = self.user!.targetGlucose?.description
            self.correctionFactorText.text = self.user!.correctionFactor?.description
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
