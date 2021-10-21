//
//  BleView.swift
//  BluetoothLab
//
//  Created by xdeveloper on 21/10/2021.
//

import SwiftUI
import CoreBluetooth

struct BleView: View {
    @ObservedObject var client = BleClient()
   
    var body: some View {
        List {
            Section(header: Text("Scan and Connect")) {
                Text(client.status)
                Button("Scan and connect", action: client.startScanning )
            }
            Section(header: Text("Heart Rate Measurement")) {
                Text("\(client.heartRateMeasurement) bpm")
                Button("Register heart rate measurement", action:  client.registerHeartRateMeasurement )
            }
            Section(header: Text("Body Sensor Location")) {
                Text(client.bodySensorLocation)
                Button("Read body sensor location", action: client.readBodySensorLocation )
            }
            Section(header: Text("Heart Rate Control Point")) {
                Button("Write 0xC9", action: { client.writeHeartRateControlPoint(Data([0xC9])) } )
                Button("Write 0xBEEF", action: { client.writeHeartRateControlPoint(Data([0xBE, 0xEF])) } )
            }
        }
    }
}

struct BleView_Previews: PreviewProvider {
    static var previews: some View {
        BleView()
    }
}

class BleClient: NSObject, ObservableObject {
    
    @Published var status = "Inited"
    @Published var heartRateMeasurement: UInt16 = 0
    @Published var bodySensorLocation: String = "Unknown"
    var centralManager: CBCentralManager?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    
    func startScanning() {
    }
    
    func registerHeartRateMeasurement() {
    }
    
    func readBodySensorLocation() {
    }
    
    func writeHeartRateControlPoint(_ controlPoint: Data) {
    }
}

extension BleClient: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        status = central.state.stringValue
    }
}

extension CBManagerState {
    
    var stringValue: String {
        switch self {
        case .poweredOff:
            return "Bluetooth is currently powered off."
        case .poweredOn:
            return "Bluetooth is currently powered on and available to use."
        case .resetting:
            return "The connection with the system service was momentarily lost."
        case .unauthorized:
            return "The application isn’t authorized to use the Bluetooth low energy role."
        case .unknown:
            return "State is unknown."
        case .unsupported:
            return "This device doesn’t support the Bluetooth low energy central or client role."
        @unknown default:
            return "State is unknown."
        }
    }
}
