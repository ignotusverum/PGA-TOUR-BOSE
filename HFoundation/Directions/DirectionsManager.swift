//
//  DirectionsManager.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/20/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

import MapboxCoreNavigation
import MapboxDirections
import MapboxNavigation

public protocol WaypointProtocol {
    var title: String { get }
    var coordinate: CLLocationCoordinate2D { get }
}

public struct HWaypoint: WaypointProtocol {
    public var title: String
    public var coordinate: CLLocationCoordinate2D
    
    public init(coordinate: CLLocationCoordinate2D,
                title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}

public class DirectionsManager: NSObject {
    public static let shared = DirectionsManager()
    public func showDirections(origin: HWaypoint,
                               paths: [HWaypoint],
                               in rootController: UIViewController) {
        let origin = Waypoint(coordinate: origin.coordinate,
                              name: origin.title)
        let path = paths.map { Waypoint(coordinate: $0.coordinate,
                                        name: $0.title) }
        
        let options = NavigationRouteOptions(waypoints: [origin] + path,
                                             profileIdentifier: .walking)
        
        rootController.showLoading()
        
        Directions.shared.calculate(options) { (_, routes, _) in
            guard let route = routes?.first else { return }
            rootController.dismiss(animated: true, completion: nil)
            
            let navigationOptions = NavigationOptions(navigationService: MapboxNavigationService(route: route,
                                                                                                 locationSource: NavigationLocationManager()))
            
            navigationOptions.styles = [NightStyle(),
                                        DayStyle()]
            navigationOptions.styles?.forEach {
                $0.mapStyleURL = URL(string: "mapbox://styles/ignotusverum/ck7vxrd0412z51inunr9zsnxl")!
            }
            
            let viewController = NavigationViewController(for: route,
                                                          options: navigationOptions)
            
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                rootController.present(viewController,
                                       animated: true,
                                       completion: nil)
            }
        }
    }
}

extension DirectionsManager: NavigationViewControllerDelegate {}

class CustomUserLocationAnnotationView: MGLUserLocationAnnotationView {
    let size: CGFloat = 48
    var dot: CALayer!
    var arrow: CAShapeLayer!
    
    override func update() {
        if frame.isNull {
            frame = CGRect(x: 0, y: 0, width: size, height: size)
            return setNeedsLayout()
        }
        
        // Check whether we have the user’s location yet.
        if CLLocationCoordinate2DIsValid(userLocation!.coordinate) {
            setupLayers()
            updateHeading()
        }
    }
    
    private func updateHeading() {
        // Show the heading arrow, if the heading of the user is available.
        if let heading = userLocation!.heading?.trueHeading {
            arrow.isHidden = false
            
            // Get the difference between the map’s current direction and the user’s heading, then convert it from degrees to radians.
            let directionDegrees = WearableSessionManager.shared.trueHeadingDegrees ?? mapView!.direction
            let rotation: CGFloat = -MGLRadiansFromDegrees(directionDegrees - heading)
            
            // If the difference would be perceptible, rotate the arrow.
            if abs(rotation) > 0.01 {
                // Disable implicit animations of this rotation, which reduces lag between changes.
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                arrow.setAffineTransform(CGAffineTransform.identity.rotated(by: rotation))
                CATransaction.commit()
            }
        } else {
            arrow.isHidden = true
        }
    }
    
    private func setupLayers() {
        // This dot forms the base of the annotation.
        if dot == nil {
            dot = CALayer()
            dot.bounds = CGRect(x: 0, y: 0, width: size, height: size)
            
            // Use CALayer’s corner radius to turn this layer into a circle.
            dot.cornerRadius = size / 2
            dot.backgroundColor = super.tintColor.cgColor
            dot.borderWidth = 4
            dot.borderColor = UIColor.white.cgColor
            layer.addSublayer(dot)
        }
        
        // This arrow overlays the dot and is rotated with the user’s heading.
        if arrow == nil {
            arrow = CAShapeLayer()
            arrow.path = arrowPath()
            arrow.frame = CGRect(x: 0, y: 0, width: size / 2, height: size / 2)
            arrow.position = CGPoint(x: dot.frame.midX, y: dot.frame.midY)
            arrow.fillColor = dot.borderColor
            layer.addSublayer(arrow)
        }
    }
    
    // Calculate the vector path for an arrow, for use in a shape layer.
    private func arrowPath() -> CGPath {
        let max: CGFloat = size / 2
        let pad: CGFloat = 3
        
        let top = CGPoint(x: max * 0.5, y: 0)
        let left = CGPoint(x: 0 + pad, y: max - pad)
        let right = CGPoint(x: max - pad, y: max - pad)
        let center = CGPoint(x: max * 0.5, y: max * 0.6)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: top)
        bezierPath.addLine(to: left)
        bezierPath.addLine(to: center)
        bezierPath.addLine(to: right)
        bezierPath.addLine(to: top)
        bezierPath.close()
        
        return bezierPath.cgPath
    }
}
