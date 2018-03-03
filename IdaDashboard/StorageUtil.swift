//
//  StorageUtil.swift
//  IdaDashboard
//
//  Created by Irfan Hasan on 3/1/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import Foundation
import CoreMotion
import os.log

struct StorageUtil {
    static func saveTrip(title: String, start: Date, end: Date, mpg: Double,
                         score: Int, distance: Double, cost: Double,
                         accelerometer: [CMAccelerometerData?], gyroscope: [CMGyroData?]) {
        let trip = Trip(title: title,start: start, end: end, mpg: mpg, score: score, distance: distance, cost: cost, accelerometer: accelerometer, gyroscope: gyroscope)
       
        var trips = [Trip]()
        
        if let savedTrips = self.loadTrips() {
            trips = savedTrips
        }
        trips.append(trip!)
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(trips, toFile: Trip.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Trip successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save trip...", log: OSLog.default, type: .error)
        }
    }
    
    static func loadTrips() -> [Trip]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Trip.ArchiveURL.path) as? [Trip]
    }
}
