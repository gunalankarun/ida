//
//  TripDetailViewController.swift
//  IdaDashboard
//
//  Created by Kevin Tai on 2/7/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TripDetailViewController: UIViewController, MKMapViewDelegate {

    // MARK: Properties
    @IBOutlet weak var tripScoreLabel: UILabel!
    @IBOutlet weak var tripDistanceLabel: UILabel!
    @IBOutlet weak var tripCostLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
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
        
        // set up map
        var minLat = trip?.locations[0].0
        var maxLat = minLat
        var minLon = trip?.locations[0].1
        var maxLon = minLon
        
        for location in (trip?.locations)! {
            maxLat = max(location.0, maxLat!)
            minLat = min(location.0, minLat!)
            
            maxLon = max(location.1, maxLon!)
            minLon = min(location.1, minLon!)
        }
        
        let center = CLLocationCoordinate2D(latitude: (minLat! + maxLat!)/2, longitude: (minLon! + maxLon!)/2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat! - minLat!)*1.3, longitudeDelta: (maxLon! - minLon!) * 1.3)
        let region = MKCoordinateRegion(center: center, span: span)
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for location in (trip?.locations)! {
            points.append(CLLocationCoordinate2D(latitude: location.0, longitude: location.1))
        }
        let polyline = MKPolyline(coordinates: points, count: points.count)
        
        mapView.delegate = self
        mapView.setRegion(region, animated: true)
        mapView.add(polyline)
    }
    
    private func setupMapview() {
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .black
        renderer.lineWidth = 3
        return renderer
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
