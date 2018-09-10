//
//  Event.swift
//  RedHatScanner
//

import UIKit

class Event {
    
    //MARK: Properties
    
    var eventName: String
    var eventLocation: String
    var eventStartDate: Date
    var eventEndDate: Date
    
    //MARK: Initialization
    
    init?(eventName: String, eventLocation: String ,eventStartDate: Date, eventEndDate: Date) {
        
        // The name must not be empty
        guard !eventName.isEmpty else {
            return nil
        }
        
        // The name must not be empty
        guard !eventLocation.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (eventStartDate <= eventEndDate) else {
            return nil
        }
        
        // Initialize stored properties.
        self.eventName = eventName
        self.eventLocation = eventLocation
        self.eventStartDate = eventStartDate
        self.eventEndDate = eventEndDate
        
    }
    
    func getEventInfo() -> String{
        return self.eventName + " " + self.eventLocation
    }
    
    func getEventDates() -> String{
        return getDateAsString(self.eventStartDate) + " - " + getDateAsString(self.eventEndDate)
    }
    
    func getDateAsString(_ date: Date) -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date)
        // convert your string to date
        let convertedDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd MMM yyyy"
        // again convert your date to string
        return formatter.string(from: convertedDate!)
    }
}
