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
        
        let target:Float = 7
        let correctionFactor:Float = 2
        
        // Variables below
        let glucose:Float! = Float(glucoseText.text!)
        let CHO:Float! = Float(CHOText.text!)
        let ratio:Float! = Float(ratioText.text!)
        
        let unitsRequired = insulinCalculation(target: target, correctionFactor: correctionFactor, glucose: glucose, CHO: CHO, ratio: ratio)
        
        unitsLabel.text = String(unitsRequired) + " Units"
        
    }
    
    func insulinCalculation (target: Float, correctionFactor: Float, glucose: Float, CHO: Float, ratio: Float) -> Int {
        var result = (CHO / ratio) + ((glucose - target) / correctionFactor) // The equation for insulin requirement
        result = round(result)
        return Int(result)
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
