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
    
    // set user's properties as updated in firebase (to save having to access firebase each time these properties are used. The properties will be added as necessary
    
    let user = Auth.auth().currentUser
    var document: DocumentReference
    var name: Any? = nil
    var username: Any? = nil
    var age: Any? = nil
    var weight: Any? = nil
    
    
    
    init() {
        
        self.document = db.collection("users").document(self.user!.uid)
        document.getDocument { (document, error) in
            if let document = document, document.exists { // check if document exists
                let dataDescription = document.data()
                // set all the properties of the class
                self.name = dataDescription!["name"]
                print("just set the name of the user")
                self.username = dataDescription!["username"]
                self.age = dataDescription!["age"]
                self.weight = dataDescription!["weight"]
            } else {
                print("Document does not exist")
            }
        }
    }
        
    
    
}
