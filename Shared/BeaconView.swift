//
//  BeaconView.swift
//  BluetoothLab
//
//  Created by xdeveloper on 21/10/2021.
//

import SwiftUI
import CoreLocation
import UserNotifications

struct BeaconView: View {
    
    @ObservedObject var detector = BeaconDetector()
    @State private var isScanning: Bool = false
    
    var body: some View {
        List {
            Section(header: Text("Monitoring")) {
                Text(detector.status)
            }
            Section(header: Text("Ranging")) {
            }
            Section(header: Text("Control")) {
                Toggle("Scan", isOn: $isScanning)
                    .onChange(of: isScanning) { value in
                        if value == true {
                            detector.startScanning()
                        } else {
                            detector.stopScanning()
                        }
                    }
                    .padding()
            }
        }
    }
}

struct BeaconView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconView()
    }
}

class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var status = "Inited"
    var locationManager = CLLocationManager()
    let uuid = UUID(uuidString: "12345678-1234-1234-1234-123456789ABC")

    var beaconRegion: CLBeaconRegion?
    
    override init() {
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        beaconRegion = CLBeaconRegion(uuid: uuid!, identifier: "M5StickC beacons");
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                self.status = error.localizedDescription
            }
            
            self.status = granted.description
        }
    }
    
    func startScanning() {
        locationManager.startMonitoring(for: beaconRegion!)
        status = "Scanning started"
    }

    func stopScanning() {
        locationManager.stopMonitoring(for: beaconRegion!)
        status = "Scanning stopped"
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        status = "Entered \(region.identifier) region."
        let content = UNMutableNotificationContent()
        content.title = "Entering region!"
        content.body = region.identifier
        content.sound = .default
            
        let request = UNNotificationRequest(identifier: "entering", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        status = "Left \(region.identifier) region."
    }
}
