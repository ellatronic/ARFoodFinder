//
//  APIManager.swift
//  ARFoodFinder
//
//  Created by Ella on 4/25/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import Foundation
import CoreLocation

class APIManager {

    func loadPOIs(for location: CLLocation, within radius: Int = 1000, completion: @escaping ([Place]) -> Void) {
        print("Load POIs")

        let apiURL = "https://api.foursquare.com/v2/venues/explore"
        let clientID = "U0H3VHFNJFUGNIMPPZWEM5YQ5SLY2TLCBQNWZBYKYVYVX5AL"
        let clientSecret = "OHT3B0H5FRFYIQ0NFJCXNVV1PX5WC21NWI3F20CMWOEQOFTI"
        let version = "20170425"
        let section = "food"
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let baseURLString = apiURL + "?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(version)&ll=\(latitude),\(longitude)&radius=\(radius)&section=\(section)&venuePhotos=1"

        print(baseURLString)

        guard let url = URL(string: baseURLString) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else { return }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }

                guard let response = json["response"] as? [String: Any] else { return }
//                print(response)
                guard let groups = response["groups"] as? [[String: Any]] else { return }
                guard let group = groups.first else { return }
                guard let items = group["items"] as? [[String: Any]] else { return }

                var places = [Place]()
                for place in items {
                    if let newPlace = Place.create(from: place) {
                        places.append(newPlace)
                    }
                }

                completion(places)

            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
