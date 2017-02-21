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
    
    func getPressure(_ completion: @escaping (_ success: Bool, _ reading: Float?) -> Void) {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.current!, withHandler: { (altdata, error) -> Void in
                self.pressure = altdata?.pressure.floatValue
                self.altimeter.stopRelativeAltitudeUpdates()
                completion(true, self.pressure * 10)
            })
        } else {
            completion(false, nil)
        }
    }
    
    func setAppMode(_ isPressureAvailable: Bool) {
        UserDefaults.standard.set(false, forKey: "DarkMode")
        if isPressureAvailable && (pressure * 10) < 1000 {
            // Based on Air Pressure, Set Dark Mode
            UserDefaults.standard.set(true, forKey: "DarkMode")
        }
        
        if !isPressureAvailable {
            let date = Date()
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.hour, .minute], from: date)
            let hour = components.hour
            if hour! >= 18 || hour! <= 6 {
                // Based on Current Time, Set Dark Mode
                UserDefaults.standard.set(true, forKey: "DarkMode")
            }
        }
    }
}
