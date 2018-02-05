//
//  Trip.swift
//  IdaDashboard
//
//  Created by Kevin Tai on 2/5/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

class Trip {
    // MARK: Properties
    var title: String
    var start: Date
    var end: Date
    var mpg: Double
    var score: Int
    
    // MARK: Initialization
    init?(title: String, start: Date, end: Date, mpg: Double, score: Int) {
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
        
        // Initialize properties
        self.title = title
        self.start = start
        self.end = end
        self.mpg = mpg
        self.score = score
    }
}
