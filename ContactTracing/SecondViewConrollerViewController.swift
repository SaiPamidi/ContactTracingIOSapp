//
//  SecondViewConrollerViewController.swift
//  ContactTracing
//
//  Created by Sai swaroop Pamidi on 7/11/20.
//  Copyright © 2020 Sai swaroop Pamidi. All rights reserved.
//

import UIKit
import CoreBluetooth

class SecondViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralManagerDelegate {
    
    
    
    private var centralManager : CBCentralManager!
    private var scanDeviceClick = true
    private var deviceNames = [String : NSNumber]()
    private var peripheralManager : CBPeripheralManager!
    private var service: CBUUID!
    
   
    @IBOutlet weak var deviceList: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is On")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not active")
        }
    }
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unknown:
            print("Bluetooth Device is UNKNOWN")
        case .unsupported:
            print("Bluetooth Device is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth Device is UNAUTHORIZED")
        case .resetting:
            print("Bluetooth Device is RESETTING")
        case .poweredOff:
            print("Bluetooth Device is POWERED OFF")
        case .poweredOn:
            print("Bluetooth Device is POWERED ON")
            addServices()
        @unknown default:
            print("Unknown State")
        }
    }
    func addServices()
    {
        let myChar1 = CBMutableCharacteristic(type: CBUUID(nsuuid: UUID()), properties: [.notify, .write, .read], value: nil, permissions: [.readable, .writeable])
        service = CBUUID(nsuuid: UUID())
        let myService = CBMutableService(type: service, primary: true)
        myService.characteristics = [myChar1]
        peripheralManager.add(myService)
        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey : "BLEPeripheralApp", CBAdvertisementDataServiceUUIDsKey :  [service]])
        print("Started Advertising")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func scanDevices(_ sender: Any) {
        if(scanDeviceClick)
        {
            print("scanning devices ....")
            deviceList.text = "scanning devices ...."
            centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
            statusLabel.text = "Advertising Data"
            peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
            scanDeviceClick = false
        }
        else
        {
            centralManager.stopScan()
            deviceList.text = "stopped scanning"
            peripheralManager.stopAdvertising()
            statusLabel.text = "stopped advertising"
            deviceNames = [:]
            scanDeviceClick = true
        }
        
    }
    
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("\nName   : \(peripheral.name ?? "(No name)")")
        //print("RSSI   : \(RSSI)")
        //fix for default values
        if(deviceNames[peripheral.name ?? "No name"] == nil)
        {
            deviceNames[peripheral.name ?? "No name"] = RSSI
            var distance = -1.0
            if let power = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? Double{ print("Distance is ", pow(10, ((power - Double(truncating: RSSI))/20)))
                distance = pow(10, ((power - Double(truncating: RSSI))/20))
            }
            
            //let devicePower = advertisementData[CBAdvertisementDataTxPowerLevelKey]
            //print("Distance is ", pow(10, ((devicePower as! Double - Double(truncating: RSSI))/20)))
            //print("\(peripheral.name ?? "No name")")
            //print(advertisementData[CBAdvertisementDataTxPowerLevelKey] ?? -1)
            //print(RSSI)
            deviceList.text = deviceList.text! +  "\n\(peripheral.name ?? "No name")" + "\(distance)"
            for ad in advertisementData {
                print("AD Data: \(ad)")
            }
        }
        //deviceList.text = "\(peripheral.name ?? "(No name)")"
        //for ad in advertisementData {
            //print("AD Data: \(ad)")
        //}
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
