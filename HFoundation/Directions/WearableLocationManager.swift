//
//  WearableLocationManager.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/20/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import CoreLocation
import Foundation

public protocol CustomLocationManagerDelegate: class {
    func customLocationManager(didUpdate locations: [CLLocation])
}

public class CustomLocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = CustomLocationManager()
    private var locationManager = CLLocationManager()
    
    weak var delegate: CustomLocationManagerDelegate?
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        delegate?.customLocationManager(didUpdate: locations)
    }
}
