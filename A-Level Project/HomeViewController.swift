//
//  HomeViewController.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 07/05/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    let adaptor = FirebaseAdaptor()
    var lightweightUser: LightweightUser? = nil
    var uid: String? = nil
    
    @IBOutlet weak var welcomLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = adaptor.getUID()
        adaptor.getLightweightUser(uid: uid!) { lightweightUser in
            self.lightweightUser = lightweightUser
            self.welcomLabel.text = "Hello, " + (lightweightUser.name ?? "")
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calculatorSegue" {
            let controller = segue.destination as! CalculatorViewController
            controller.uid = self.uid
        } else if segue.identifier == "profileSegue" {
            let controller = segue.destination as! ProfileViewController
            controller.uid = self.uid
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
