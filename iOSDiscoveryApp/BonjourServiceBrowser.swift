//
//  BonjourServiceBrowser.swift
//  iOSDiscoveryApp
//
//  Created by Sam Horvath on 4/2/25.
//

import Foundation
import Network
import Combine

struct DiscoveredService: Identifiable {
    var id: String { name + type }
    let name: String
    let type: String
    let endpoint: NWEndpoint
}

class BonjourServiceBrowser: ObservableObject {
    private var browser: NWBrowser?
    @Published var discoveredServices: [DiscoveredService] = []
    private let logPrefix = "🔍📱"
    
    func logSection(_ title: String) {
        let line = String(repeating: "=", count: 20)
        print("\n\(logPrefix) \(line) \(title) \(line)")
    }
    
    func log(_ message: String, level: LogLevel = .info) {
        let timestamp = formattedTimestamp()
        let emoji = level.emoji
        print("\(logPrefix) \(emoji) [\(timestamp)] \(level.rawValue.uppercased()): \(message)")
    }
    
    enum LogLevel: String {
        case debug = "debug"
        case info = "info"
        case notice = "notice"
        case warning = "warning"
        case error = "error"
        case success = "success"
        
        var emoji: String {
            switch self {
            case .debug: return "🔧"
            case .info: return "ℹ️"
            case .notice: return "📣"
            case .warning: return "⚠️"
            case .error: return "❌"
            case .success: return "✅"
            }
        }
    }
    
    private func formattedTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
    
    func startBrowsing() {
        print("🔍📱 Starting to browse for Bonjour services...")
        
        // Define the service type to browse for
        let bonjourType = "_example._tcp"
        
        // Create the browser
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
        // Initialize the browser with the bonjour service type
        browser = NWBrowser(for: .bonjour(type: bonjourType, domain: "local"), using: parameters)
        
        // Set up the state update handler
        browser?.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                print("🔍📱 Browser is ready and actively discovering")
            case .failed(let error):
                print("🔍📱 Browser failed with error: \(error)")
            case .cancelled:
                print("🔍📱 Browser was cancelled")
            default:
                print("🔍📱 Browser state changed: \(state)")
            }
        }
        
        // Set up the results handler
        browser?.browseResultsChangedHandler = { [weak self] results, changes in
            print("🔍📱 Browse results changed - found \(results.count) services")
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self?.discoveredServices = results.compactMap { result in
                    if case .service(let name, let type, let domain, _) = result.endpoint {
                        print("🔍📱 Found service: \(name) of type \(type) in domain \(domain)")
                        return DiscoveredService(name: name, type: type, endpoint: result.endpoint)
                    }
                    return nil
                }
            }
        }
        
        // Start the browser with the required queue parameter
        print("🔍📱 Starting the browser...")
        let queue = DispatchQueue(label: "com.example.browser")
        browser?.start(queue: queue)
        print("🔍📱 Browser started on custom queue")
    }
    
    func stopBrowsing() {
        print("🔍📱 Stopping Bonjour service discovery")
        browser?.cancel()
        discoveredServices = []
    }
}
