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
     This value is passed by `TripTableViewController` in `prepare(for:sender:)`
     */
    var trip: Trip!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up views if editing an existing Trip.
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
    
    @IBAction func exportData(_ sender: UIBarButtonItem) {
        guard let trip = trip, let url = trip.exportToFileURL() else {
            print("problem")
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: ["ida trip export", url],
            applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = sender
        }
        present(activityViewController, animated: true, completion: nil)
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
