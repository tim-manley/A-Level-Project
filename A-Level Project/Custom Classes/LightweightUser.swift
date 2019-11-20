//
//  LightweightUser.swift
//  A-Level Project
//
//  Created by Manley, Timothy (PRKB) on 11/11/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import Foundation

class LightweightUser {
    
    var uid: String
    var name: String?
    var readings: [Reading]?
    
    init(uid: String, name: String?, readings: [Reading]) {
        self.uid = uid
        self.name = name
        self.readings = readings
    }
    
    
}
