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
//import Charts

class TripDetailVC: UIViewController, MKMapViewDelegate {

    // MARK: Properties
    @IBOutlet weak var tripScoreLabel: UILabel!
    @IBOutlet weak var tripDistanceLabel: UILabel!
    @IBOutlet weak var tripCostLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
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
            
            // set up map
            mapView.delegate = self
            if trip.locations.count != 0 {
                var minLat = trip.locations[0]?.coordinate.latitude
                var maxLat = minLat
                var minLon = trip.locations[0]?.coordinate.longitude
                var maxLon = minLon
                
                var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
                
                for location in trip.locations {
                    let coordinate = location?.coordinate
                    maxLat = max((coordinate?.latitude)!, maxLat!)
                    minLat = min((coordinate?.latitude)!, minLat!)
                    
                    maxLon = max((coordinate?.longitude)!, maxLon!)
                    minLon = min((coordinate?.longitude)!, minLon!)
                    
                    points.append(coordinate!)
                }
                
                // setup map region
                let center = CLLocationCoordinate2D(latitude: (minLat! + maxLat!)/2, longitude: (minLon! + maxLon!)/2)
                let span = MKCoordinateSpan(latitudeDelta: (maxLat! - minLat!)*1.3, longitudeDelta: (maxLon! - minLon!) * 1.3)
                let region = MKCoordinateRegion(center: center, span: span)
                mapView.setRegion(region, animated: true)
                
                // add route
                let polyline = MKPolyline(coordinates: points, count: points.count)
                mapView.add(polyline)
                
                // add start + end annotation
                let startAnno = MKPointAnnotation()
                startAnno.coordinate = (trip.locations[0]?.coordinate)!
                startAnno.title = "Start"
                let endAnno = MKPointAnnotation()
                endAnno.coordinate = (trip.locations[trip.locations.count-1]?.coordinate)!
                endAnno.title = "End"
                mapView.addAnnotations([startAnno, endAnno])
            }
        } else {
            fatalError("Displaying TripDetail without backing information")
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
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
