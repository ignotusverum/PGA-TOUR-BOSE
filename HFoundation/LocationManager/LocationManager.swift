//
//  LocationManager.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

import CoreLocation
import Foundation

public enum LocationManagerEvents: EventProtocol {
    case locationStatusChanged(CLAuthorizationStatus)
}

public class LocationManager: NSObject, EventsProducer {
    public var disposeBag = DisposeBag()
    
    public static var lastLocation: CLLocation?
    
    public static var shared = LocationManager()
    public static var locationProvider = CLLocationManager()
    
    public var events: Observable<LocationManagerEvents> { return _events }
    private let _events = PublishSubject<LocationManagerEvents>()
    
    public override init() {
        super.init()
        
        _events.onNext(.locationStatusChanged(CLLocationManager.authorizationStatus()))
    }
    
    public func requestPermissions() {
        LocationManager.locationProvider.requestAlwaysAuthorization()
        
        LocationManager.locationProvider.delegate = self
        
        LocationManager.locationProvider.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.locationProvider.startUpdatingLocation()
        
        LocationManager.locationProvider.allowsBackgroundLocationUpdates = true
        LocationManager.locationProvider.pausesLocationUpdatesAutomatically = false
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        _events.onNext(.locationStatusChanged(status))
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        LocationManager.lastLocation = locations.last
    }
}
