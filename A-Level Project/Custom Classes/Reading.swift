//
//  Reading.swift
//  A-Level Project
//
//  Created by Manley, Timothy (PRKB) on 11/11/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import Foundation

class Reading {
    
    var timeStamp: String
    var bloodGlucose: Float
    var carbohydrates: Int
    var amountOfInsulin: Int
    
    init(timeStamp: String, bloodGlucose: Float, carbohydrates: Int, amountOfInsulin: Int) {
        self.timeStamp = timeStamp
        self.bloodGlucose = bloodGlucose
        self.carbohydrates = carbohydrates
        self.amountOfInsulin = amountOfInsulin
    }
}
