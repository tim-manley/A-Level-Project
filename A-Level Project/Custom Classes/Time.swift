//
//  Time.swift
//  A-Level Project
//
//  Created by Manley, Timothy (PRKB) on 14/11/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import Foundation

class Time {
    
    // Returns the current date and time
    func getDate() -> String {
        
        let date = Date()
        //let date = self.getSomeTimeAgo() // For adding readings at earlier dates
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let today_string = dateFormatter.string(from: date)

        return today_string
    }
    
    // Returns the date last week
    func getOneWeekAgo() -> Date {
        
        let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())
        
        return lastWeek!
    }
    
    // Returns the date and time exactly 24 hours ago
    func getYesterday() -> Date {
        
        let today = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        return today!
    }
    
    // Returns the date and time on the same day of the last month
    func getMonthAgo() -> Date {
        
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        return lastMonth!
    }
    
    // Returns the date and time on the same day in the same month of last year
    func getYearAgo() -> Date {
        
        let lastYear = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        
        return lastYear!
    }
    
    // Converts a date in string format to an actual date object (for comparisons)
    func parseDate(date: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let parsedDate = dateFormatter.date(from: date)
        
        return parsedDate!
    }
    
    
    
    // Testing function
    private func getSomeTimeAgo() -> Date {
        
        let timeAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date())
        
        return timeAgo!
    }
}
