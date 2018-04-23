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
import SwiftySound

class ActiveTripVC: UIViewController, CLLocationManagerDelegate {
    var bluetoothIO: BluetoothIO!
    var bluetoothDelegateId: Int!

    @IBOutlet weak var lSpeed: UILabel!
    @IBOutlet weak var lDistance: UILabel!
    @IBOutlet weak var lTime: UILabel!
    @IBOutlet weak var lSharpLeft: UILabel!
    @IBOutlet weak var lSharpRight: UILabel!
    @IBOutlet weak var lHardBrake: UILabel!
    @IBOutlet weak var lHardAccel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    // queue for the moion manager
    private let queue = OperationQueue()
    
    // vals for location
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionManager()
    
    // vals for acceleromter/gyroscope thresholds
    private let sharpTurnThresh = 0.3
    private let hardAccelThresh = 0.4
    private let delayThresh = 5.0

    // vars for new trip
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var motionList: [CMDeviceMotion] = []
    private var sharpLeftTurnCount = 0
    private var sharpRightTurnCount = 0
    private var hardBrakeCount = 0
    private var hardAccelCount = 0
    private var lastEvent: TimeInterval = 0
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startMotionUpdates()
        
        bluetoothIO = BluetoothIO.shared
        bluetoothDelegateId = bluetoothIO.registerDelegate(delegate: self)
        bluetoothIO.writeValue(value: BluetoothIO.START_TRIP)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        motionManager.stopDeviceMotionUpdates()
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
        
        DispatchQueue.main.async {
            self.lDistance.text = "\(formattedDistance)"
            self.lTime.text = "\(formattedTime)"
        }
    }
    
    private func startMotionUpdates() {
        if self.motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0/60.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                            to: self.queue, withHandler: { (data, error) in
                            // Make sure the data is valid before accessing it.
                            if let validData = data {
                                self.motionList.append(validData)
                                self.processMotionData(validData: validData)
                            }
            })
        }
    }
    
    private func processMotionData(validData: CMDeviceMotion) {
        if(validData.timestamp - lastEvent < delayThresh) {
            return
        }
        if(validData.userAcceleration.x < -sharpTurnThresh) {
            print(validData.userAcceleration.x)
            sharpRightTurnCount += 1
            lastEvent = validData.timestamp
            DispatchQueue.main.async {
                self.lSharpRight.text = String(self.sharpRightTurnCount)
            }
        } else if(validData.userAcceleration.x > sharpTurnThresh) {
            print(validData.userAcceleration.x)
            sharpLeftTurnCount += 1
            lastEvent = validData.timestamp
            DispatchQueue.main.async {
                self.lSharpLeft.text = String(self.sharpLeftTurnCount)
            }
        } else if(validData.userAcceleration.y < -hardAccelThresh) {
            print(validData.userAcceleration.y)
            hardAccelCount += 1
            lastEvent = validData.timestamp
            DispatchQueue.main.async {
                self.lHardAccel.text = String(self.hardAccelCount)
            }
        } else if(validData.userAcceleration.y > hardAccelThresh) {
            print(validData.userAcceleration.y)
            hardBrakeCount += 1
            lastEvent = validData.timestamp
            DispatchQueue.main.async {
                self.lHardBrake.text = String(self.hardBrakeCount)
            }
        }
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
                                 motion: self.motionList, sharpLeftTurn: self.sharpLeftTurnCount,
                                 sharpRightTurn: self.sharpRightTurnCount,
                                 hardBrake: self.hardBrakeCount, hardAccel: self.hardAccelCount,
                                 locations: self.locationList)
            self.cleanup()
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title:"Don't Save", style: UIAlertActionStyle.default) { _ in
            self.cleanup()
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel))
        self.present(alert, animated: true)
    }
    
    private func cleanup() {
        self.bluetoothIO.unregisterDelegate(id: self.bluetoothDelegateId)
        self.bluetoothIO.writeValue(value: BluetoothIO.END_TRIP)
        self.motionManager.stopGyroUpdates()
        self.motionManager.stopAccelerometerUpdates()
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
        let location = locations[0]
        
        let howrecent = location.timestamp.timeIntervalSinceNow
        if (location.horizontalAccuracy < 20) && (abs(howrecent) < 10) {
            if let lastLocation = locationList.last {
                let delta = location.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                locationList.append(location)
            } else if locationList.count == 0 {
                locationList.append(location)
            }
        }
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span:span)

        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
        updateDisplay()
        //lSpeed.text = "\(location.speed) mph"
        lSpeed.text = "45 mph"
    }
}

extension ActiveTripVC: BluetoothIODelegate {
    static let NO_ALERT: Int8 = 48
    
    func bluetoothIO(bluetoothIO: BluetoothIO, didReceiveValue value: Int8) {
        print(value)
        
        if value != ActiveTripVC.NO_ALERT && self.presentedViewController == nil {
            let alertController = UIAlertController(title: "Drowsy Alert", message: "You are falling asleep!", preferredStyle: .alert)
            
            Sound.stopAll()
            Sound.play(file: "iphone_alarm", fileExtension: "mp3", numberOfLoops: -1)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                Sound.stopAll()
            }

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

