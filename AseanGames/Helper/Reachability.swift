//
//  Reachability.swift
//  Klasio
//
//  Created by Digital Khrisna on 4/4/17.
//  Copyright © 2017 Codigo. All rights reserved.
//

import Alamofire

public class Reachability {
    
    public enum ReachabilityStatus {
        case unreachable
        case reachable
    }
    
    public typealias ReachabilityHandler = ((_ reach: Reachability) -> Void)
    public typealias NotReachabilityHandler = ((_ reach: Reachability) -> Void)
    
    open var reachabilityHandler: ReachabilityHandler
    open var notReachabilityHandler: NotReachabilityHandler
    
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "google.com")
    
    init(reachabilityHandler: @escaping ReachabilityHandler, notReachabilityHandler: @escaping NotReachabilityHandler) {
        self.reachabilityHandler = reachabilityHandler
        self.notReachabilityHandler = notReachabilityHandler
    }
    
    deinit {
        print("Dealloc reachability class")
    }
    
    func startListening() {
        self.listenForReachability()
    }
    
    func stopListening() {
        self.reachabilityManager?.stopListening()
    }
    
    private func listenForReachability() {
        self.reachabilityManager?.listener = { [weak self] status in
            guard let strongSelf = self else { return }
            switch status {
            case .notReachable:
                strongSelf.notReachabilityHandler(strongSelf)
                return
            case .reachable(_), .unknown:
                strongSelf.reachabilityHandler(strongSelf)
                return
            }
            
            
        }
        
        self.reachabilityManager?.startListening()
    }
}
