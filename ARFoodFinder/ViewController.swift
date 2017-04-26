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
    fileprivate var arViewController: ARViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
//        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }

    @IBAction func showARController(_ sender: Any) {
        arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.maxVisibleAnnotations = 30
        arViewController.headingSmoothingFactor = 0.05
        arViewController.setAnnotations(places)
        self.present(arViewController, animated: true, completion: nil)
    }

    // MARK: - Helper Functions
    func showInfoView(forPlace place: Place) {
        //1
        let alert = UIAlertController(title: place.name , message: place.id, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //2
        arViewController.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let location = locations.last!
            print("Accuracy: \(location.horizontalAccuracy)")
            
            if location.horizontalAccuracy < 100 {
                manager.stopUpdatingLocation()
                let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.region = region

                if !startedLoadingPOIs {
                    startedLoadingPOIs = true

                    let apiManager = APIManager()
                    apiManager.loadPOIs(for: location, within: 1_000, completion: { (loadedPlaces) in
                        print("Finding POIs")
                        self.places = loadedPlaces

                        let annotations = loadedPlaces.map({ (place) -> PlaceAnnotation in
                            return PlaceAnnotation(location: place.location!.coordinate, title: place.name)
                        })

                        DispatchQueue.main.async {
                            annotations.forEach({ (annotation) in
                                self.mapView.addAnnotation(annotation)
                            })
                        }
                    })
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location")
    }
}

extension ViewController: ARDataSource, AnnotationViewDelegate {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)

        return annotationView
    }

    func didTouch(annotationView: AnnotationView) {
//        print("Tapped view for POI: \(String(describing: annotationView.titleLabel?.text))")
        print(annotationView)
//        if let annotation = annotationView.annotation as? Place {
//            self.showInfoView(forPlace: Place)
//        }

    }
}
