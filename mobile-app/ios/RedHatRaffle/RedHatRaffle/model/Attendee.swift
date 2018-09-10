//
//  Attendee.swift
//  RedHatScanner
//
//  Created by Ted Jones - Red Hat on 12/13/17.
//

import UIKit

class Attendee {
    
    //MARK: Properties
    
    var attendeeFirstName: String 
    var attendeeLastName: String
    var uid: String
    
    //MARK: Initialization
    
    init?(attendeeFirstName: String, attendeeLastName: String, uid: String ) {
        
        // The first name must not be empty
        guard !attendeeFirstName.isEmpty else {
            return nil
        }
        
        // The name must not be empty
        guard !attendeeLastName.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.attendeeFirstName = attendeeFirstName
        self.attendeeLastName = attendeeLastName
        self.uid = uid
        
    }
    
}


