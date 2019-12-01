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
    
    init(uid: String, name: String?, readings: [Reading]?) {
        self.uid = uid
        self.name = name
        self.readings = readings
    }
    
    public func getReadingsInTimescale(timescale: String) -> [Reading]? {
        
        if self.readings != nil {
            let time = Time()
            var timescaleDate: Date
            switch timescale {
            case "Today":
                timescaleDate = time.getToday()
            case "Past Week":
                timescaleDate = time.getOneWeekAgo()
            case "Past Month":
                timescaleDate = time.getMonthAgo()
            case "Past Year":
                timescaleDate = time.getYearAgo()
            default:
                timescaleDate = Date()
            }
            
            var scaledReadings: [Reading] = []
            
            for reading in self.readings! {
                let parsedDate = time.parseDate(date: reading.timeStamp)
                if parsedDate > timescaleDate {
                    scaledReadings.append(reading)
                }
            }
            return scaledReadings
        
        } else {
            return nil
        }
    }
    
}
