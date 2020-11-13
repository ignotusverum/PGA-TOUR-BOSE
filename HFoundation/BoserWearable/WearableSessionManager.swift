//
//  WearableSessionManager.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/13/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import BLECore
import BoseWearable

import MERLin

import CoreLocation
import simd
import WorldMagneticModel

public enum WearableSessionManagerEvents: EventProtocol {
    case device(WearableDevice?)
    case event(WearableDeviceEvent)
    case sessionDidOpen
    case didClose(Error?)
    case didFailToOpen(Error)
    
    case receivedGesture(GestureType, SensorTimestamp)
    
    case receivedGyroscope(Vector, VectorAccuracy, SensorTimestamp)
    case receivedAccelerometer(Vector, VectorAccuracy, SensorTimestamp)
    
    case trueHeadingDegreesChanged(Double?)
    case receivedRotation(Quaternion, QuaternionAccuracy, SensorTimestamp)
}

public class WearableSessionManager:
    NSObject,
    EventsProducer {
    public typealias SharedType = WearableSessionManager
    public var disposeBag = DisposeBag()
    
    private let sensorDispatch = SensorDispatch(queue: .main)
    
    public var session: WearableDeviceSession? {
        didSet {
            guard let session = session else { return }
            
            self.session?.delegate = self
            _events.onNext(.device(session.device))
            
            token = session.device?.addEventListener(queue: .main) { [weak self] in
                guard let self = self else { return }
                self._events.onNext(.event($0))
            }
            
            configureSensors()
            configureGestures()
            sensorDispatch.handler = self
        }
    }
    
    public static var shared = WearableSessionManager()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private let worldMagneticModel: WMMModel = {
        do { return try WMMModel() }
        catch { fatalError("Could not load World Magnetic Model: \(error)") }
    }()
    
    /// The magnetic heading as reported by the Bose Wearable device. If this value is `nil`, no heading has been received yet.
    private var magneticHeadingDegrees: Double?
    
    public var trueHeadingDegrees: Double? {
        // We can't compute the true heading if magnetic heading or current location is nil.
        guard let heading = magneticHeadingDegrees,
            let location = LocationManager.locationProvider.location else { return nil }
        
        // Compute the magnetic declination based on the current location
        let elem = worldMagneticModel.elements(for: location)
        let decl = elem.decl
        
        // The true heading is the magnetic heading plus the declination.
        return heading + decl
    }
    
    public var events: Observable<WearableSessionManagerEvents> { return _events }
    private let _events = PublishSubject<WearableSessionManagerEvents>()
    
    private var token: ListenerToken?
    
    private func configureSensors() {
        guard let device = session?.device else { return }
        device.configureSensors { config in
            config.disableAll()
            
            config.enable(sensor: .rotation, at: ._20ms)
            config.enable(sensor: .gyroscope, at: ._20ms)
            config.enable(sensor: .accelerometer, at: ._20ms)
        }
    }
    
    private func configureGestures() {
        guard let device = session?.device else { return }
        device.configureGestures { config in
            config.disableAll()
            config.set(gesture: .doubleTap, enabled: true)
        }
    }
}

extension WearableSessionManager: WearableDeviceSessionDelegate {
    public func sessionDidOpen(_ session: WearableDeviceSession) {
        _events.onNext(.sessionDidOpen)
    }
    
    public func session(_ session: WearableDeviceSession,
                        didFailToOpenWithError error: Error) {
        _events.onNext(.didFailToOpen(error))
    }
    
    public func session(_ session: WearableDeviceSession,
                        didCloseWithError error: Error) {
        _events.onNext(.didClose(error))
    }
    
    public func sessionDidClose(_ session: WearableDeviceSession) {
        _events.onNext(.didClose(nil))
    }
}

extension WearableSessionManager: SensorDispatchHandler {
    public func receivedAccelerometer(vector: Vector,
                                      accuracy: VectorAccuracy,
                                      timestamp: SensorTimestamp) {
        _events.onNext(.receivedAccelerometer(vector,
                                              accuracy,
                                              timestamp))
    }
    
    public func receivedGyroscope(vector: Vector,
                                  accuracy: VectorAccuracy,
                                  timestamp: SensorTimestamp) {
        _events.onNext(.receivedGyroscope(vector,
                                          accuracy,
                                          timestamp))
    }
    
    public func receivedGesture(type: GestureType,
                                timestamp: SensorTimestamp) {
        _events.onNext(.receivedGesture(type,
                                        timestamp))
    }
    
    public func receivedRotation(quaternion: Quaternion,
                                 accuracy: QuaternionAccuracy,
                                 timestamp: SensorTimestamp) {
        let qMap = Quaternion(ix: 1, iy: 0, iz: 0, r: 0)
        let qResult = quaternion * qMap
        let yaw = -qResult.zRotation
        
        // The quaternion yaw value is the heading in radians. Convert to degrees.
        magneticHeadingDegrees = yaw * 180 / Double.pi
        
        _events.onNext(.trueHeadingDegreesChanged(trueHeadingDegrees))
        
        _events.onNext(.receivedRotation(quaternion,
                                         accuracy,
                                         timestamp))
    }
}
