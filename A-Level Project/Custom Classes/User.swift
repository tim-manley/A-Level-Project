//
//  User.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 30/04/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import Foundation
import Firebase

class User {
    
    var uid: String
    var username: String
    var name: String?
    var age: Int?
    var weight: Float?
    var targetGlucose: Float?
    var correctionFactor: Int?
    var readings: [Reading]?
    
    init(uid: String, username: String, name: String?, age: Int?, weight: Float?, targetGlucose: Float?, correctionFactor: Int?, readings: [Reading]) {
        self.uid = uid
        self.username = username
        self.name = name
        self.age = age
        self.weight = weight
        self.targetGlucose = targetGlucose
        self.correctionFactor = correctionFactor
        self.readings = readings
    }
}
