//
//  CJAltimeter.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/16/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import Foundation
import CoreMotion

class CJAltimeter {
    
    let altimeter = CMAltimeter()
    
    var pressure: Float!
    
    func getPressure(completion: (success: Bool, reading: Float?) -> Void) {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (altdata, error) -> Void in
                self.pressure = altdata?.pressure.floatValue
                self.altimeter.stopRelativeAltitudeUpdates()
                completion(success: true, reading: self.pressure * 10)
            })
        } else {
            completion(success: false, reading: nil)
        }
    }
    
    func setAppMode(isPressureAvailable: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "DarkMode")
        if isPressureAvailable && (pressure * 10) < 1000 {
            // Based on Air Pressure, Set Dark Mode
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "DarkMode")
        }
        
        if !isPressureAvailable {
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Hour, .Minute], fromDate: date)
            let hour = components.hour
            if hour >= 18 || hour <= 6 {
                // Based on Current Time, Set Dark Mode
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "DarkMode")
            }
        }
    }
}