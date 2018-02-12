//
//  BluetoothViewController.swift
//  IdaDashboard
//
//  Created by Gunalan Karun on 2/5/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

class BluetoothViewController: UIViewController {
    var simpleBluetoothIO: SimpleBluetoothIO!

    override func viewDidLoad() {
        super.viewDidLoad()

        simpleBluetoothIO = SimpleBluetoothIO(serviceUUID: "19B10010-E8F2-537E-4F6C-D104768A1214", delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension BluetoothViewController: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: Int8) {
        if value > 0 {
            view.backgroundColor = UIColor.yellow
        } else {
            view.backgroundColor = UIColor.black
        }
    }
}
