//
//  BonjourService.swift
//  SimpleBonjourExample
//
//  Created by Sam Horvath on 4/2/25.
//

import Foundation
import Network

class BonjourServiceAdvertiser: ObservableObject {
    private var listener: NWListener?
    @Published var isAdvertising = false
    
    func startAdvertising() {
        print("📡 [Mac] Starting to advertise Bonjour service...")
        
        // Create a TCP listener
        let parameters = NWParameters.tcp
        parameters.includePeerToPeer = true
        
        do {
            // Create a listener
            listener = try NWListener(using: parameters)
            
            // Set the service name and type
            let serviceName = "MacBonjourExample"
            let serviceType = "_example._tcp"
            print("📡 [Mac] Setting up service: \(serviceName) of type \(serviceType)")
            
            // Create and configure the service (simplest possible configuration)
            listener?.service = NWListener.Service(name: serviceName, type: serviceType)
            
            // Add a connection handler (required for service to work)
            listener?.newConnectionHandler = { connection in
                print("📡 [Mac] Received connection from: \(connection.endpoint)")
                connection.start(queue: .main)
            }
            
            listener?.stateUpdateHandler = { [weak self] state in
                switch state {
                case .ready:
                    print("📡 [Mac] SUCCESS: Bonjour service is now being advertised!")
                    DispatchQueue.main.async {
                        self?.isAdvertising = true
                    }
                case .failed(let error):
                    print("📡 [Mac] ERROR: Failed to advertise service: \(error)")
                    DispatchQueue.main.async {
                        self?.isAdvertising = false
                    }
                default:
                    break
                }
            }
            
            print("📡 [Mac] Starting the listener...")
            listener?.start(queue: .main)
        } catch {
            print("📡 [Mac] ERROR: Failed to create listener: \(error)")
        }
    }
    
    func stopAdvertising() {
        print("📡 [Mac] Stopping Bonjour service advertisement")
        listener?.cancel()
        isAdvertising = false
        print("📡 [Mac] Bonjour service advertisement stopped")
    }
} 