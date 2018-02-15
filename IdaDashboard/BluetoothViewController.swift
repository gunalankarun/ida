//
//  BluetoothViewController.swift
//  IdaDashboard
//
//  Created by Gunalan Karun on 2/5/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

class BluetoothViewController: UIViewController {
    var bluetoothIO: BluetoothIO!

    override func viewDidLoad() {
        super.viewDidLoad()

        bluetoothIO = BluetoothIO(serviceUUID: "f0d87fa5-f367-4112-9cf0-0f1bd061b8a2", delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension BluetoothViewController: BluetoothIODelegate {
    func bluetoothIO(bluetoothIO: BluetoothIO, didReceiveValue value: Int8) {
        print(value)
        if value > 0 {
            view.backgroundColor = UIColor.yellow
        } else {
            view.backgroundColor = UIColor.black
        }
    }
}
