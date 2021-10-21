//
//  ContentView.swift
//  Shared
//
//  Created by xdeveloper on 21/10/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BeaconView().tabItem {
                Image(systemName: "waveform.circle.fill")
                Text("iBeacons")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
