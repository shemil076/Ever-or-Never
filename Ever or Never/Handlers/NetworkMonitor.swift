//
//  NetworkMonitor.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-12-05.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = false
    
    let monitor = NWPathMonitor()
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                //                self.isConnected = path.status == .satisfied
                
                if path.status == .satisfied {
                    self.isConnected = path.status == .satisfied
                    print("Connected? \(self.isConnected)")
                }else{
                    print("No connected")
                }
            }
        }
        
        // Start the monitor here, not inside the pathUpdateHandler
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
}
