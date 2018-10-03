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
    private let newPin = MKPointAnnotation()
    private let coordinateDelta = 0.3
    private let circleLocations:[CLLocation] = [CLLocation(latitude: 37.6879, longitude: -122.4702),
                                                CLLocation(latitude: 37.879646, longitude: -122.533328),
                                                CLLocation(latitude: 37.804444, longitude: -122.270833)]
    private let circleRadius: CLLocationDistance = 4000
    
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setMonitoringEnterRegion() {
        for location in circleLocations {
            self.addRadiusCircle(location: location)
            let region = CLCircularRegion(center: location.coordinate,
                                          radius: circleRadius,
                                          identifier: "Circle")
            region.notifyOnEntry = true
            region.notifyOnExit = false
            locationManager.startMonitoring(for: region)
        }
    }
    
    private func addRadiusCircle(location: CLLocation){
        let circle = MKCircle(center: location.coordinate, radius: circleRadius)
        mapView.add(circle)
    }
}

extension FourthViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            let randomColor = UIColor.randomColor()
            circle.strokeColor = randomColor
            circle.fillColor = randomColor.withAlphaComponent(0.3)
            circle.lineWidth = 2
            return circle
        } else if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
}

extension FourthViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpanMake(coordinateDelta, coordinateDelta))
            newPin.coordinate = location
            mapView.setRegion(region, animated: true)
            mapView.addAnnotation(newPin)
            
            for circleLocation in circleLocations {
                let request = MKDirectionsRequest()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: location))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: circleLocation.coordinate))
                request.requestsAlternateRoutes = true
                request.transportType = .automobile
                
                let directions = MKDirections(request: request)
                
                directions.calculate { response, error in
                    guard let unwrappedResponse = response else { return }
                    self.mapView.add(unwrappedResponse.routes.first!.polyline)
                    self.mapView.setVisibleMapRect(unwrappedResponse.routes.first!.polyline.boundingMapRect, animated: true)
                }
            }
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
