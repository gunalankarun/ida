//
//  Helper.swift
//  IdaDashboard
//
//  Created by Gunalan Karun on 3/28/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

/*
 Ring Colors:
 Red:       UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
 Orange:    UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
 Yellow:    UIColor(red:1.00, green:0.92, blue:0.23, alpha:1.0)
 LGreen:    UIColor(red:0.55, green:0.76, blue:0.29, alpha:1.0)
 Green:     UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
 */

class Helper{
    static let HARD_BREAK_PENALTY = 0.7
    static let SHARP_TURN_PENALTY = 0.7
    static let DROWSINESS_PENALTY = 5.0
    static let DIST_CONST = 20.0
    
    static func getRingColor(score:Int) -> UIColor {
        var color:UIColor
        
        if(score < 20) {
            color = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        } else if(score < 40) {
            color = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        } else if(score < 60) {
            color = UIColor(red:1.00, green:0.92, blue:0.23, alpha:1.0)
        } else if(score < 80) {
            color = UIColor(red:0.55, green:0.76, blue:0.29, alpha:1.0)
        } else {
            color = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        }
        return color
    }
    
    static func calcDriverScore(dist:Double, hard_breaks:Int, sharp_turns:Int,
                                drowsiness_alerts:Int) -> Double {
        
        let hard = Double(hard_breaks)
        let sharp = Double(sharp_turns)
        let drowsiness = Double(drowsiness_alerts)
        
        let dist_weight = (4.5 * exp(-dist/DIST_CONST)) + 1.5
        
        let penalty = hard * HARD_BREAK_PENALTY + sharp * SHARP_TURN_PENALTY + drowsiness * DROWSINESS_PENALTY
        return 100.0 - dist_weight * penalty
    }
}
