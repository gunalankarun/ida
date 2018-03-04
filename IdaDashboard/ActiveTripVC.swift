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
import CoreMotion
import os.log

class ActiveTripVC: UIViewController, CLLocationManagerDelegate {
    var bluetoothIO: BluetoothIO!
    var bluetoothDelegateId: Int!

    // UIs
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lSpeed: UILabel!
    @IBOutlet weak var lDistance: UILabel!
    @IBOutlet weak var lTime: UILabel!
    
    // vars for location
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionManager()
    
    // vars for new trip
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var accelerometer: [CMAccelerometerData?] = []
    private var gyroscope: [CMGyroData?] = []
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        getData()
        
        bluetoothIO = BluetoothIO.shared
        bluetoothDelegateId = bluetoothIO.registerDelegate(delegate: self)
        bluetoothIO.writeValue(value: BluetoothIO.START_TRIP)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        createAlert(title: "Drowsy Alert", message: "You are falling asleep!")
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
    
    // MARK: Private
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        
        seconds += 1
        
        lDistance.text = "\(formattedDistance)"
        lTime.text = "\(formattedTime)"
    }
    
    private func getData() {
        if (self.motionManager.isAccelerometerAvailable) {
            print("acquiring acceleration")
            self.acquireAcceleration()
        }
        if (self.motionManager.isGyroAvailable) {
            print("acquiring gyroscope")
            self.acquireGyro()
        }
    }
    
    private func acquireAcceleration() {
        self.motionManager.accelerometerUpdateInterval = 1/10
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!,
                                     withHandler: {
            (data: CMAccelerometerData?, error: Error?) in
            DispatchQueue.main.async(execute: { () in
                if(error != nil) {
                    self.accelerometer.append(nil)
                } else {
                    self.accelerometer.append(data)
                }
            })
        })
    }
    
    private func acquireGyro() {
        self.motionManager.gyroUpdateInterval = 1/10
        self.motionManager.startGyroUpdates(to: OperationQueue.current!,
                                    withHandler: {
            (data: CMGyroData?, error: Error?) in
            DispatchQueue.main.async(execute: { () in
                if(error != nil) {
                    self.gyroscope.append(nil)
                } else {
                    self.gyroscope.append(data)
                }
            })
        })
    }
    
    
    @IBAction func endTrip(_ sender: Any) {
        let alert = UIAlertController(title: "End Trip", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title:"Save", style: UIAlertActionStyle.default) { _ in
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd.yyyy"
            let dateStr = formatter.string(from: date)
            let title = "Trip on: " + dateStr
            
            StorageUtil.saveTrip(title: title, start: date, end: date, mpg: Double(arc4random_uniform(100) + 40), score: Int(arc4random_uniform(100)), distance: Double(arc4random_uniform(100) + 40), cost: Double(arc4random_uniform(100) + 40),
                                 accelerometer: self.accelerometer, gyroscope: self.gyroscope)
            self.bluetoothIO.unregisterDelegate(id: self.bluetoothDelegateId)
            self.bluetoothIO.writeValue(value: BluetoothIO.END_TRIP)
            self.performSegue(withIdentifier: "unwindToDashboard", sender: self)
        })
        alert.addAction(UIAlertAction(title:"Don't Save", style: UIAlertActionStyle.default) { _ in
            self.bluetoothIO.unregisterDelegate(id: self.bluetoothDelegateId)
            self.bluetoothIO.writeValue(value: BluetoothIO.END_TRIP)
            self.performSegue(withIdentifier: "unwindToDashboard", sender: self)
        })
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel))
        self.present(alert, animated: true)
    }
    
    /*
    creates an alert for drowsiness detection
    */
    private func createAlert (title: String, message: String) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated:true, completion: nil)
        }))
        
        self.present(alert, animated:true, completion: nil)
    }
    
    /*
    location updates
    */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let howrecent = location.timestamp.timeIntervalSinceNow
            guard location.horizontalAccuracy < 20 && abs(howrecent) < 10 else {continue}
            
            if let lastLocation = locationList.last {
                let delta = location.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            }
            
            locationList.append(location)
        }
        
        let location = locations[0]
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span:span)

        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
        updateDisplay()
        lSpeed.text = "\(location.speed) mph"
    }
    
    
}

extension ActiveTripVC: BluetoothIODelegate {
    static let ALERT: Int8 = 49
    
    func bluetoothIO(bluetoothIO: BluetoothIO, didReceiveValue value: Int8) {
        print(value)
        if value == ActiveTripVC.ALERT {
            createAlert(title: "Drowsy Alert", message: "You are falling asleep!")
        }
    }
}

