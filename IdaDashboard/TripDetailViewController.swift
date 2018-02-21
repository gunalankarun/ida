//
//  TripDetailViewController.swift
//  IdaDashboard
//
//  Created by Kevin Tai on 2/7/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var tripScoreLabel: UILabel!
    @IBOutlet weak var tripDistanceLabel: UILabel!
    @IBOutlet weak var tripCostLabel: UILabel!
    
    /*
     This value is either passed by `TripTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up views if editing an existing Meal.
        if let trip = trip {
            tripScoreLabel.text   = String(trip.score)
            tripDistanceLabel.text = String(trip.distance)
            tripCostLabel.text = "$" + String(trip.cost)
        } else {
            fatalError("Displaying TripDetail without backing information")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
