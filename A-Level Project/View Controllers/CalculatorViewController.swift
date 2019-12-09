//
//  CalculatorViewController.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 26/02/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var glucoseText: UITextField!
    @IBOutlet weak var CHOText: UITextField!
    @IBOutlet weak var ratioText: UITextField!
    
    @IBOutlet weak var unitsLabel: UILabel!
    
    var uid: String? = nil
    let adaptor = FirebaseAdaptor()
    var user: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adaptor.getUser() { user in
            self.user = user // Instantiate the current user object
        }
    }
    
    @IBAction func calculateInsulin(_ sender: Any) {
        
        // The user specific values
        guard let target = user!.targetGlucose else {
            self.createAlert(title: "No user blood glucose target",
                             message: "You must first set a blood glucose target, go to: Manage Profile.")
            return
        }
        guard let correctionFactor = user!.correctionFactor else {
            self.createAlert(title: "No user correction factor",
                             message: "You must first set a correction factor for your insulin, go to: Manage Profile.")
            return
        }
        
        // Reading specific variables below
        let glucose:Float! = Float(glucoseText.text!)
        let CHO:Float! = Float(CHOText.text!)
        let ratio:Float! = Float(ratioText.text!)
        
        let unitsRequired = insulinCalculation(target: target,
                                               correctionFactor: Float(correctionFactor),
                                               glucose: glucose,
                                               CHO: CHO,
                                               ratio: ratio)
        
        unitsLabel.text = String(unitsRequired) + " Units"
        
        let time = Time() // Use the time class to get the reading's timestamp
        
        // Create a reading object with the field values
        let reading = Reading(timeStamp: time.getDate(),
                              bloodGlucose: glucose,
                              carbohydrates: Int(CHO),
                              amountOfInsulin: unitsRequired)
        
        // Add the reading to the user's list of readings
        user!.readings?.append(reading)
        
        // Update firebase with the new reading
        adaptor.addReading(user: user!)
    }
    
    func insulinCalculation (target: Float, correctionFactor: Float, glucose: Float, CHO: Float, ratio: Float) -> Int {
        var result = (CHO / ratio) + ((glucose - target) / correctionFactor) // The equation for insulin requirement
        result = round(result)
        return Int(result)
    }
    
    // This function manages the UI for displaying alerts
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
