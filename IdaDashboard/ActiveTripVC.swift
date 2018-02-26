//
//  ActiveTripVC.swift
//  IdaDashboard
//
//  Created by Peter Zhang on 2/25/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import os.log

class ActiveTripVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    private func locationManger(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region = MKCoordinateRegionMake(myLocation, span)
        
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //manager.delegate = self
        //manager.desiredAccuracy = kCLLocationAccuracyBest
        //manager.requestWhenInUseAuthorization()
        //manager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createAlert(title: "Drowsy Alert", message: "You are falling asleep!")
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
    
    @IBAction func endTrip(_ sender: Any) {
        let alert = UIAlertController(title: "End Trip", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title:"Save", style: UIAlertActionStyle.default) { _ in
            self.performSegue(withIdentifier: "unwindToDashboard", sender: self)
        })
        alert.addAction(UIAlertAction(title:"Don't Save", style: UIAlertActionStyle.default) { _ in
            self.performSegue(withIdentifier: "unwindToDashboard", sender: self)
        })
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel))
        self.present(alert, animated: true)
    }
    
    private func createAlert (title: String, message: String) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated:true, completion: nil)
        }))
        
        self.present(alert, animated:true, completion: nil)
    }
}
