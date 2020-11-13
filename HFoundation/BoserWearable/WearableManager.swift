//
//  WearableManager.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/13/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

import BLECore
import BoseWearable
import CoreBluetooth
import WorldMagneticModel

typealias BoseWearable = BoseWearableLib

public enum WearableManagerEvents: EventProtocol {
    case bluetoothStatusChanged(CBPeripheralManagerAuthorizationStatus)
}

public class WearableManager:
    NSObject,
    EventsProducer,
    SharedProtocol {
    public typealias SharedType = WearableManager
    
    public var events: Observable<WearableManagerEvents> { return _events }
    private let _events = PublishSubject<WearableManagerEvents>()
    
    public var disposeBag = DisposeBag()
    public static var shared = WearableManager()
    
    public class func configure() {
        if CBPeripheralManager.authorizationStatus() != .restricted {
            BoseWearableLib.configure()
        }
    }
    
    public class func createConnection() -> Single<WearableDeviceSession> {
        Single.create { observer in
            BoseWearable.shared.startConnection(mode: getCurrentConnectMode()) { result in
                switch result {
                case .success(let session): observer(.success(session))
                case .failure(let error): observer(.error(error))
                case .cancelled: break
                }
            }
            
            return Disposables.create()
        }
    }
    
    private class func getCurrentConnectMode() -> ConnectUIMode {
//        switch MostRecentlyConnectedDevice.get() {
//        case .some(let device): return .reconnect(device: device)
//        case .none: return .alwaysShow
//        }
        return .alwaysShow
    }
    
    public override init() {
        super.init()
        
        _events.onNext(.bluetoothStatusChanged(CBPeripheralManager.authorizationStatus()))
    }
}

extension WearableManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        _events.onNext(.bluetoothStatusChanged(CBPeripheralManager.authorizationStatus()))
    }
}
