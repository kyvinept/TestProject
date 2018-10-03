//
//  FourthViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class FourthViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("FourthViewController", comment: "")
        self.navigationController?.delegate = self
        setLocationManager()
        setMonitoringEnterRegion()
    }
    
    private func setLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setMonitoringEnterRegion() {
        self.addRadiusCircle(location: CLLocation(latitude: 37.6879, longitude: -122.4702))
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 37.6879, longitude: -122.4702),
                                      radius: 4000,
                                  identifier: "Circle")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        locationManager.startMonitoring(for: region)
    }
    
    private func addRadiusCircle(location: CLLocation){
        let circle = MKCircle(center: location.coordinate, radius: 4000)
        self.mapView.add(circle)
    }
}

extension FourthViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255,
                                     green: 0,
                                      blue: 0,
                                     alpha: 0.3)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
}

extension FourthViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpanMake(0.2, 0.2))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Error",
                                    message: "Check your internet connection or allow this app tracking your location.",
                             preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again",
                                      style: .default,
                                    handler: nil))
        self.present(alert,
                     animated: true,
                   completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alert = UIAlertController(title: "Enter",
                                    message: "You enter in circle",
                             preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                    handler: nil))
        self.present(alert,
                     animated: true,
                   completion: nil)
    }
}

extension FourthViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return AnimationFromRightCorner()
        default:
            return nil
        }
    }
}
