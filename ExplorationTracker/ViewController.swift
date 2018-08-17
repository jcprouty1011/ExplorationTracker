//
//  ViewController.swift
//  ExplorationTracker
//
//  Created by Jeffrey Prouty on 8/11/18.
//  Copyright © 2018 Jeffrey Prouty. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var snapMode = false

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mapSubview: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 10 //meters
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 42.3591, longitude: -71.0933, zoom: 16.0)
        //let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapSubview.settings.myLocationButton = true
        mapSubview.isMyLocationEnabled = true
        //self.mapView = mapView
        //mapSubview = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 42.3591, longitude: -71.0933)
        marker.map = mapSubview
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        if snapMode {
            GoogleAPIHelper.requestSnappedPoint(location: location)
        } else {
            print(location.horizontalAccuracy)
            topLabel.text = "Location: \(location)"
            if location.horizontalAccuracy <= 50 {
                let circle = GMSCircle(position: location.coordinate, radius: 10)
                circle.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: min(CGFloat(5 / location.horizontalAccuracy), 1))
                circle.strokeColor = .none
                circle.map = mapSubview
            }
        }
    }

}

