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
        print("Execute API Manager")

        let apiURL = "https://api.foursquare.com/v2/venues/explore"
        let clientID = "U0H3VHFNJFUGNIMPPZWEM5YQ5SLY2TLCBQNWZBYKYVYVX5AL"
        let clientSecret = "OHT3B0H5FRFYIQ0NFJCXNVV1PX5WC21NWI3F20CMWOEQOFTI"
        let version = "20170425"
        let section = "food"
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let baseURLString = apiURL + "?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(version)&ll=\(latitude),\(longitude)&radius=\(radius)&section=\(section)&venuePhotos=1"

        guard let url = URL(string: baseURLString) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else { return }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }

                guard let response = json["response"] as? [String: Any] else { return }
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

    func loadVenuePhotos(forVenue venueID: String, completion: @escaping ([String]) -> Void) {
        print("Loading venue photos")
        let apiURL = "https://api.foursquare.com/v2/venues/"
        let clientID = "U0H3VHFNJFUGNIMPPZWEM5YQ5SLY2TLCBQNWZBYKYVYVX5AL"
        let clientSecret = "OHT3B0H5FRFYIQ0NFJCXNVV1PX5WC21NWI3F20CMWOEQOFTI"
        let version = "20170425"

        let baseURLString = "\(apiURL)\(venueID)/photos?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(version)&limit=11"

        guard let url = URL(string: baseURLString) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else { return }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }

                guard let response = json["response"] as? [String: Any] else { return }
                guard var photos = response["photos"] as? [String: Any] else { return }
                guard let items = photos["items"] as? [[String: Any]] else { return }

                var itemsArray = [String]()

                for i in 0..<items.count {
                    guard let prefix = items[i]["prefix"] else { return }
                    guard let suffix = items[i]["suffix"] else { return }
                    itemsArray.append("\(prefix)original\(suffix)")
                }
                print(itemsArray)

                completion(itemsArray)

            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
