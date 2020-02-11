//
//  AppDelegateEvents.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import RxSwift

enum AppDelegateEvent: EventProtocol {
    case willFinishLaunching(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
}
