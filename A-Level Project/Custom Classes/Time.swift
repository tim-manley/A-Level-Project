//
//  Time.swift
//  A-Level Project
//
//  Created by Manley, Timothy (PRKB) on 14/11/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import Foundation

class Time {
    
    func getDate() -> String {
        
        let date = Date()
        //let date = self.getSomeTimeAgo() // For adding readings at earlier dates
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let today_string = dateFormatter.string(from: date)

        return today_string
    }
    
    func getOneWeekAgo() -> Date {
        
        let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())
        
        return lastWeek!
    }
    
    // Testing function
    private func getSomeTimeAgo() -> Date {
        
        let timeAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date())
        
        return timeAgo!
    }
    
    func getToday() -> Date {
        
        let today = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        return today!
    }
    
    func getMonthAgo() -> Date {
        
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        return lastMonth!
    }
    
    func getYearAgo() -> Date {
        
        let lastYear = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        
        return lastYear!
    }
    func parseDate(date: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let parsedDate = dateFormatter.date(from: date)
        
        return parsedDate!
    }
    
    func getTimeStamp(withTimescale: String, timeStamp: String) -> String {
        
        var axisLabel: String
        
        switch withTimescale {
        case "Today":
            axisLabel = String(timeStamp.split(separator: " ")[1])
        case "Past Week":
            axisLabel = String(timeStamp.split(separator: " ")[0])
        case "Past Month":
            axisLabel = String(timeStamp.split(separator: " ")[0])
        case "Past Year":
            let date = String(timeStamp.split(separator: " ")[0])
            axisLabel = String(date.split(separator: "-")[0] + "-" + date.split(separator: "-")[1])
        default:
            axisLabel = timeStamp
        }
        
        
        return axisLabel
    }
}
