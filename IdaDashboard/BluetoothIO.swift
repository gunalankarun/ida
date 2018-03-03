import CoreBluetooth

protocol BluetoothIODelegate: class {
    func bluetoothIO(bluetoothIO: BluetoothIO, didReceiveValue value: Int8)
}

class BluetoothIO: NSObject {
    static let shared = BluetoothIO(serviceUUID: "f0d87fa5-f367-4112-9cf0-0f1bd061b8a2")
    let serviceUUID: String
    var delegates: [Int: BluetoothIODelegate]
    var delegateId: Int
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var targetService: CBService?
    var writableCharacteristic: CBCharacteristic?
    
    private init(serviceUUID: String) {
        print("Initializing Bluetooth Manager...")
        self.serviceUUID = serviceUUID
        self.delegates = [:]
        self.delegateId = 0
        
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func writeValue(value: Int8) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        
        let data = Data.dataWithValue(value: value)
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func registerDelegate(delegate: BluetoothIODelegate) -> Int {
        delegateId = delegateId + 1
        self.delegates[delegateId] = delegate
        return delegateId
    }
    
    func unregisterDelegate(id: Int) {
        self.delegates[id] = nil
    }
    
    func notifyDelegates(bluetoothIO: BluetoothIO, didReceiveValue: Int8) {
        for (_, delegate) in self.delegates {
            delegate.bluetoothIO(bluetoothIO: bluetoothIO, didReceiveValue: didReceiveValue)
        }
    }
}

extension BluetoothIO: CBCentralManagerDelegate {
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Discovering Services...")
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Connecting to Peripheral Device...")
        connectedPeripheral = peripheral
        
        if let connectedPeripheral = connectedPeripheral {
            connectedPeripheral.delegate = self
            centralManager.connect(connectedPeripheral, options: nil)
            print("Connected to Peripheral Device.")
        }
        centralManager.stopScan()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Scanning for Peripheral Device...")
            centralManager.scanForPeripherals(withServices: [CBUUID(string: serviceUUID)], options: nil)
        }
    }
}

extension BluetoothIO: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovering Characteristics...")
        guard let services = peripheral.services else {
            return
        }
        
        targetService = services.first
        if let service = services.first {
            targetService = service
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        print("Subscribing to characteristic...")
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                writableCharacteristic = characteristic
            }
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {
            return
        }
        
        notifyDelegates(bluetoothIO: self, didReceiveValue: data.int8Value())
    }
}
