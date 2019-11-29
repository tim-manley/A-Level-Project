//
//  Validator.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 04/06/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import Foundation

class Validator {
    
    // These errors provide a message to be displayed in an alert in the case of an error
    let errors = [1: "Username must have 5 or more characters",
                  2: "Username must have 15 or fewer characters",
                  3: "Username must not contain spaces",
                  4: "Email must contain an '@'",
                  5: "Email must not contain spaces",
                  6: "Email must have 10 or more characters",
                  7: "Email must have 32 or fewer characters",
                  8: "Email must contain a '.' after the '@'",
                  9: "Password must have 8 or more characters",
                  10: "Password must have 24 or fewer characters",
                  11: "Password must contain a number",
                  12: "Password must contain an uppercase letter"]
    
    private func checkForNumber(str: String) -> Bool {
        for i in 0...9 {
            if str.contains(String(i)) {
                return true
            }
        }
        return false
    }
    
    private func checkForUCase(str: String) -> Bool {
        let lowerCase = str.lowercased()
        if lowerCase == str {
            return false
        }
        return true
    }
    
    func validateUsername(username: String) -> Int? {
        if username.count < 5 {
            return 1
        } else if username.count > 15 {
            return 2
        } else if (username.contains(" ")) {
            return 3
        }
        return nil
    }
    
    func validateEmail(email: String) -> Int? {
        if email.contains("@") == false {
            return 4
        } else if email.contains(" ") {
            return 5
        } else if email.count < 10 {
            return 6
        } else if email.count > 32 {
            return 7
        } else {
            let atIndex = email.firstIndex(of: "@")
            let domain = email[atIndex!...]
            if domain.contains(".") == false {
                return 8
            }
        }
        return nil
    }
    
    func validatePassword(password: String) -> Int? {
        if password.count < 8 {
            return 9
        } else if password.count > 24 {
            return 10
        } else if checkForNumber(str: password) == false {
            return 11
        } else if checkForUCase(str: password) == false {
            return 12
        }
        return nil
    }
    
    
    
}

