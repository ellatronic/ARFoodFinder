//
//  ViewController.swift
//  ARFoodFinder
//
//  Created by Ella on 4/25/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    fileprivate var startedLoadingPOIs = false
    fileprivate var places = [Place]()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }

    @IBAction func showARController(_ sender: Any) {
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let location = locations.last!
            print("Accuracy: \(location.horizontalAccuracy)")
            
//            if location.horizontalAccuracy < 100 {
//                manager.stopUpdatingLocation()
                let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.region = region
                // More code later...

                let apiManager = APIManager()
                apiManager.loadPOIs(for: location, within: 1_000, completion: { (loadedPlaces) in
                    self.places = loadedPlaces
                    let annotation = PlaceAnnotation(location: self.places[0].location!.coordinate, title: self.places[0].name)
//                    for place in self.places {
//                        let annotation = PlaceAnnotation(location: place.location!.coordinate, title: place.name)
//                    }
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(annotation)
//                        dump(self.places)
                    }
                })
//            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location")
    }
}
