//
//  AccelerometerViewController.swift
//  IdaDashboard
//
//  Created by Kevin Tai on 3/2/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class SensorViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var accelXLabel: UILabel!
    @IBOutlet weak var accelYLabel: UILabel!
    @IBOutlet weak var accelZLabel: UILabel!
    @IBOutlet weak var gyroXLabel: UILabel!
    @IBOutlet weak var gyroYLabel: UILabel!
    @IBOutlet weak var gyroZLabel: UILabel!
    @IBOutlet weak var gpsLatLabel: UILabel!
    @IBOutlet weak var gpsLonLabel: UILabel!
    
    let motionManager = CMMotionManager()
    
    var accelX: Double = 0.0
    var accelY: Double = 0.0
    var accelZ: Double = 0.0
    
    var gyroX: Double = 0.0
    var gyroY: Double = 0.0
    var gyroZ: Double = 0.0
    
    var gpsLat: Double = 0.0
    var gpsLon: Double = 0.0
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.motionManager.stopAccelerometerUpdates()
        self.motionManager.stopGyroUpdates()
    }
    
    // MARK: Private methods
    private func getData() {
        if (self.motionManager.isAccelerometerAvailable) {
            self.acquireAcceleration()
        } else {
            self.accelXLabel.text = "    X: Not supported"
            self.accelYLabel.text = "    Y: Not supported"
            self.accelZLabel.text = "    Z: Not supported"
        }
        
        if (self.motionManager.isGyroAvailable) {
            self.acquireGyro()
        } else {
            self.gyroXLabel.text = "    X: Not supported"
            self.gyroYLabel.text = "    Y: Not supported"
            self.gyroZLabel.text = "    Z: Not supported"
        }
    }
    
    private func acquireAcceleration() {
        self.motionManager.accelerometerUpdateInterval = 1/10
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!,
                                    withHandler: {
            (data: CMAccelerometerData?, error: Error?) in
            DispatchQueue.main.async(execute: { () in
                print("acquire acceleration")
                guard let exData = data, error == nil else {
                    return
                }
                self.accelX = exData.acceleration.x
                self.accelY = exData.acceleration.y
                self.accelZ = exData.acceleration.z
                self.updateAccelerometerLabels()
            })
        })
    }
    
    private func acquireGyro() {
        self.motionManager.gyroUpdateInterval = 1/10
        self.motionManager.startGyroUpdates(to: OperationQueue.current!,
                                    withHandler: {
            (data: CMGyroData?, error: Error?) in
            DispatchQueue.main.async(execute: { () in
                print("acquire gyro")
                guard let exData = data, error == nil else {
                    return
                }
                self.gyroX = exData.rotationRate.x
                self.gyroY = exData.rotationRate.y
                self.gyroZ = exData.rotationRate.z
                self.updateGyroscopeLabels()
            })
        })
    }
    
    private func updateAccelerometerLabels() {
        accelXLabel.text = String(format: "    X: %f", accelX)
        accelYLabel.text = String(format: "    Y: %f", accelY)
        accelZLabel.text = String(format: "    Z: %f", accelZ)
    }
    
    private func updateGyroscopeLabels() {
        gyroXLabel.text = String(format: "    X: %f", gyroX)
        gyroYLabel.text = String(format: "    Y: %f", gyroY)
        gyroZLabel.text = String(format: "    Z: %f", gyroZ)
    }
    
    private func updateGPSLabels() {
        gpsLatLabel.text = String(format: "    Lat: %f", gpsLat)
        gpsLonLabel.text = String(format: "    Lon: %f", gpsLon)
    }
}
