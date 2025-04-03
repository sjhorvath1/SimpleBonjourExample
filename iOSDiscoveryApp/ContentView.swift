//
//  ContentView.swift
//  iOSDiscoveryApp
//
//  Created by Sam Horvath on 4/2/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var serviceBrowser = BonjourServiceBrowser()
    @State private var isScanning = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Status indicator
                HStack {
                    Circle()
                        .fill(isScanning ? Color.green : Color.red)
                        .frame(width: 12, height: 12)
                    Text(isScanning ? "Scanning for services..." : "Not scanning")
                        .font(.subheadline)
                }
                .padding(.top)
                
                // List of discovered services
                List {
                    if serviceBrowser.discoveredServices.isEmpty {
                        Text("No services found")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        ForEach(serviceBrowser.discoveredServices) { service in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(service.name)
                                    .font(.headline)
                                Text("Type: \(service.type)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                // Button to toggle scanning
                Button(action: {
                    isScanning.toggle()
                    if isScanning {
                        serviceBrowser.startBrowsing()
                    } else {
                        serviceBrowser.stopBrowsing()
                    }
                }) {
                    Text(isScanning ? "Stop Scanning" : "Start Scanning")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isScanning ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Bonjour Services")
            .onAppear {
                // Start scanning automatically when the view appears
                serviceBrowser.startBrowsing()
                isScanning = true
                // Print a log to verify this is running
                print("🔍 [iOS] ContentView appeared - starting Bonjour service discovery")
            }
            .onDisappear {
                serviceBrowser.stopBrowsing()
                isScanning = false
            }
        }
    }
}

#Preview {
    ContentView()
}
