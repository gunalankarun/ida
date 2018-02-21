//
//  TripTableViewController.swift
//  IdaDashboard
//
//  Created by Kevin Tai on 2/5/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

class TripTableViewController: UITableViewController {
    // MARK: Properties
    var trips = [Trip]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load sample data
        loadSampleTrips()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TripTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? TripTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TripTableViewCell.")
        }
        
        // Get the trip for the current row
        let trip = trips[indexPath.row]

        // Configure the cell...
        cell.tripLabel.text = trip.title
        cell.startLabel.text = convertToString(date: trip.start)
        cell.mpgLabel.text = String(format: "MPG: %.1f", trip.mpg)
        cell.scoreLabel.text = String(format: "%d", trip.score)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "ShowTripDetail":
            guard let tripDetailViewController = segue.destination as? TripDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTripCell = sender as? TripTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedTripCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTrip = trips[indexPath.row]
            tripDetailViewController.trip = selectedTrip
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    }

    // MARK: Private Methods
    // Load sample data for demonstration purposes
    private func loadSampleTrips() {
        guard let trip1 = Trip(title: "Home to UT",
                               start: Date(timeIntervalSinceNow: -1000),
                               end: Date(timeIntervalSinceNow: -900),
                               mpg: 19.2,
                               score: 90,
                               distance: 28.3,
                               cost: 4.32) else {
            fatalError("Unable to instantiate trip1")
        }
        guard let trip2 = Trip(title: "Taco Joint to EER",
                               start: Date(timeIntervalSinceNow: -800),
                               end: Date(timeIntervalSinceNow: -700),
                               mpg: 29.2,
                               score: 75,
                               distance: 192.3,
                               cost: 1.23) else {
            fatalError("Unable to insantiate trip2")
        }
        guard let trip3 = Trip(title: "UT to Home",
                               start: Date(timeIntervalSinceNow: -600),
                               end: Date(timeIntervalSinceNow: -500),
                               mpg: 40.2,
                               score: 86,
                               distance: 1.32,
                               cost: 0.32) else {
            fatalError("Unable to insantiate trip3")
        }
        
        trips += [trip1, trip2, trip3]
    }
    
    // Convert Date to String
    private func convertToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let newDate: String = dateFormatter.string(from: date) // pass Date here
        return newDate
    }
}
