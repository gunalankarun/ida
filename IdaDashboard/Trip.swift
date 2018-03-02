//
//  Trip.swift
//  IdaDashboard
//
//  Created by Kevin Tai on 2/5/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit
import CoreMotion
import os.log

class Trip: NSObject, NSCoding {
    // MARK: Properties
    var title: String
    var start: Date
    var end: Date
    var mpg: Double
    var score: Int
    var distance: Double
    var cost: Double
    var accelerometer: [CMAccelerometerData?]
    var gyroscope: [CMGyroData?]
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Trips")
    
    //MARK: Types
    
    struct PropertyKey {
        static let title = "title"
        static let start = "start"
        static let end = "end"
        static let mpg = "mpg"
        static let score = "score"
        static let distance = "distance"
        static let cost = "cost"
        static let accelerometer = "accelerometer"
        static let gyroscope = "gyroscope"
    }
    
    
    // MARK: Initialization
    init?(title: String, start: Date, end: Date, mpg: Double, score: Int,
          distance: Double, cost: Double, accelerometer: [CMAccelerometerData?],
          gyroscope: [CMGyroData?]) {
        // Title must not be empty
        guard !title.isEmpty else {
            return nil
        }
        // start date must be equal to or before end date
        guard start <= end else {
            return nil
        }
        // Can't have negative mpg
        guard mpg >= 0 else {
            return nil
        }
        // Score must be in the range [0, 100]
        guard score >= 0 && score <= 100 else {
            return nil
        }
        // Cost must be nonnegative
        guard cost >= 0 else {
            return nil
        }
        // Distance must be nonnegative
        guard distance >= 0 else {
            return nil
        }
        
        // Initialize properties
        self.title = title
        self.start = start
        self.end = end
        self.mpg = mpg
        self.score = score
        self.distance = distance
        self.cost = cost
        self.accelerometer = accelerometer
        self.gyroscope = gyroscope
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(start, forKey: PropertyKey.start)
        aCoder.encode(end, forKey: PropertyKey.end)
        aCoder.encode(mpg, forKey: PropertyKey.mpg)
        aCoder.encode(score, forKey: PropertyKey.score)
        aCoder.encode(distance, forKey: PropertyKey.distance)
        aCoder.encode(cost, forKey: PropertyKey.cost)
        aCoder.encode(accelerometer, forKey: PropertyKey.accelerometer)
        aCoder.encode(gyroscope, forKey: PropertyKey.gyroscope)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the name for a Trip object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let start = aDecoder.decodeObject(forKey: PropertyKey.start) as! Date
        let end = aDecoder.decodeObject(forKey: PropertyKey.end) as! Date
        let mpg = aDecoder.decodeDouble(forKey: PropertyKey.mpg)
        let score = aDecoder.decodeInteger(forKey: PropertyKey.score)
        let distance = aDecoder.decodeDouble(forKey: PropertyKey.distance)
        let cost = aDecoder.decodeDouble(forKey: PropertyKey.cost)
        let accelerometer = aDecoder.decodeObject(forKey: PropertyKey.accelerometer) as! [CMAccelerometerData?]
        let gyroscope = aDecoder.decodeObject(forKey: PropertyKey.gyroscope) as! [CMGyroData?]
        
        // Must call designated initializer.
        self.init(title: title, start:start, end: end, mpg: mpg, score: score, distance: distance, cost: cost, accelerometer: accelerometer, gyroscope: gyroscope)
    }
    
    public func toString() -> String {
        return title + " " + distance.description
    }
}
