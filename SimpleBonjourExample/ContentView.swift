//
//  ContentView.swift
//  SimpleBonjourExample
//
//  Created by Sam Horvath on 4/2/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var serviceAdvertiser = BonjourServiceAdvertiser()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "network")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 60))
            
            Text("Bonjour Service Example")
                .font(.title2)
            
            Text("Status: \(serviceAdvertiser.isAdvertising ? "Advertising" : "Not Advertising")")
                .foregroundColor(serviceAdvertiser.isAdvertising ? .green : .red)
                .font(.headline)
            
            Button(action: {
                if serviceAdvertiser.isAdvertising {
                    serviceAdvertiser.stopAdvertising()
                } else {
                    serviceAdvertiser.startAdvertising()
                }
            }) {
                Text(serviceAdvertiser.isAdvertising ? "Stop Advertising" : "Start Advertising")
                    .padding()
                    .background(serviceAdvertiser.isAdvertising ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Spacer()
            
            Text("Run the iOS app to discover this service")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}

#Preview {
    ContentView()
}
