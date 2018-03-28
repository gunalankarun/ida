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
}
