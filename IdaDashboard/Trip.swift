//
//  Trip.swift
//  IdaDashboard
//
//  Created by Kevin Tai on 2/5/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
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
    var motion: [CMDeviceMotion]
    var locations: [CLLocation?]
    var sharpLeft: Int
    var sharpRight: Int
    var hardBrake: Int
    var hardAccel: Int
    
    //TODO: Track these 3 metrics during the trip
    //var drowsiness_alerts: Double
    
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
        static let motion = "motion"
        static let locations = "locations"
        static let sharpLeft = "sharp_left"
        static let sharpRight = "sharp_right"
        static let hardBrake = "hard_brake"
        static let hardAccel = "hard_accel"
        static let drowsiness_alerts = "drowsiness_alerts"
    }
    
    
    // MARK: Initialization
    init?(title: String, start: Date, end: Date, mpg: Double, score: Int,
          distance: Double, cost: Double, motion: [CMDeviceMotion], sharpRightTurn: Int, sharpLeftTurn: Int, hardBrake: Int, hardAccel: Int, locations: [CLLocation?]) {
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
        self.motion = motion
        self.sharpLeft = sharpLeftTurn
        self.sharpRight = sharpRightTurn
        self.hardBrake = hardBrake
        self.hardAccel = hardAccel
        self.locations = locations
    }
    
    // MARK: Exporting
    func exportToFileURL() -> URL? {
        var contents: String = ""
        contents += title + "\n"
        contents += convertToString(date: start) + "\n"
        contents += convertToString(date: end) + "\n"
        contents += String(mpg) + "\n"
        contents += String(score) + "\n"
        contents += String(distance) + "\n"
        contents += String(cost) + "\n"
        contents += "\n"
        contents += "time,accel_x,accel_y,accel_z,gyro_x,gyro_y,gyro_z\n"
        
        for i in stride(from: 0, to: motion.count - 1, by:1) {
            var line: String = String(motion[i].timestamp)
            let a = motion[i].userAcceleration
            let g = motion[i].rotationRate
            line += "," + String(a.x) + "," + String(a.y) + "," + String(a.z)
            line += "," + String(g.x) + "," + String(g.y) + "," + String(g.z)
            contents += line + "\n"
        }
        
        // get temporary directory path
        let path = FileManager.default.temporaryDirectory
        
        // 5
        let saveFileURL = path.appendingPathComponent("/\(convertToString(date:start)).ida")
        print(String(describing: saveFileURL))
        do {
            try contents.write(to: saveFileURL, atomically: false, encoding: .utf8)
        } catch {
            return nil
        }
        return saveFileURL
    }
    
    // MARK: Private Methods
    // Convert Date to String
    private func convertToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy_HHmm"
        let newDate: String = dateFormatter.string(from: date) // pass Date here
        return newDate
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
        aCoder.encode(motion, forKey: PropertyKey.motion)
        aCoder.encode(sharpLeft, forKey: PropertyKey.sharpLeft)
        aCoder.encode(sharpRight, forKey: PropertyKey.sharpRight)
        aCoder.encode(hardAccel, forKey: PropertyKey.hardAccel)
        aCoder.encode(hardBrake, forKey: PropertyKey.hardBrake)
        aCoder.encode(locations, forKey: PropertyKey.locations)
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
        let motion = aDecoder.decodeObject(forKey: PropertyKey.motion) as! [CMDeviceMotion]
        let sharpLeft = aDecoder.decodeInteger(forKey: PropertyKey.sharpLeft)
        let sharpRight = aDecoder.decodeInteger(forKey: PropertyKey.sharpRight)
        let hardAccel = aDecoder.decodeInteger(forKey: PropertyKey.hardAccel)
        let hardBrake = aDecoder.decodeInteger(forKey: PropertyKey.hardBrake)
        let locations = aDecoder.decodeObject(forKey: PropertyKey.locations) as! [CLLocation?]
        // Must call designated initializer.
        self.init(title: title, start:start, end: end, mpg: mpg, score: score, distance: distance, cost: cost, motion: motion, sharpRightTurn: sharpRight, sharpLeftTurn: sharpLeft, hardBrake: hardBrake, hardAccel: hardAccel, locations: locations)
    }
    
    public func toString() -> String {
        return title + " " + distance.description
    }
}
