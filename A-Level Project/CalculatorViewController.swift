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
    
    @IBAction func calculateInsulin(_ sender: Any) {
        
        let target:Int = 120
        let correctionFactor:Int = 50
        
        // Variables below
        let glucose:Int! = Int(glucoseText.text!)
        let CHO:Int! = Int(CHOText.text!)
        let ratio:Int! = Int(ratioText.text!)
        
        let unitsRequired = (CHO / ratio) + ((glucose - target) / correctionFactor) // The equation for insulin requirement
        
        unitsLabel.text = String(unitsRequired) + " Units"
        
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
