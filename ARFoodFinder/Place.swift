//
//  Place.swift
//  ARFoodFinder
//
//  Created by Ella on 4/25/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import Foundation
import CoreLocation

class Place: ARAnnotation {
    let id: String
    let name: String
    let formattedPhone: String
    let formattedAddress: String

    init(location: CLLocation, id: String, name: String, formattedPhone: String, formattedAddress: String) {
        self.id = id
        self.name = name
        self.formattedPhone = formattedPhone
        self.formattedAddress = formattedAddress

        super.init()
        self.location = location
    }

    static func create(from dictionary: [String: Any]) -> Place? {
        guard let venue = dictionary["venue"] as? [String: Any] else { return nil }
        guard let id = venue["id"] as? String else { return nil }
        guard let name = venue["name"] as? String else { return nil }

        guard let contact = venue["contact"] as? [String: Any] else { return nil }
        guard let formattedPhone = contact["formattedPhone"] as? String else { return nil }

        guard let jsonLocation = venue["location"] as? [String: Any] else { return nil }
        guard let lat = jsonLocation["lat"] as? CLLocationDegrees else { return nil }
        guard let lng = jsonLocation["lng"] as? CLLocationDegrees else { return nil }
        let location = CLLocation(latitude: lat, longitude: lng)

        guard let addressArray = jsonLocation["formattedAddress"] as? [String] else { return nil }
        let formattedAddress = "\(addressArray[0]) \n\(addressArray[1])"

        return Place(location: location, id: id, name: name, formattedPhone: formattedPhone, formattedAddress: formattedAddress)
    }
    
//    var author: String
//    var title: String
//    var articleURL: String
//    var imageURL: String
//
//    init(author: String, title: String, articleURL: String, imageURL: String) {
//        self.author = author
//        self.title = title
//        self.articleURL = articleURL
//        self.imageURL = imageURL
//    }
//
//    static func create(from dictionary: [String: Any]) -> Article? {
//        // get author from json
//        guard let author = dictionary["author"] as? String else { return nil }
//
//        // get title
//        guard let title = dictionary["title"] as? String else { return nil }
//
//        // get articleURL
//        guard let articleURL = dictionary["url"] as? String else { return nil }
//
//        // get imageURL
//        guard let imageURL = dictionary["urlToImage"] as? String else { return nil }
//
//        return Article(author: author, title: title, articleURL: articleURL, imageURL: imageURL)
//    }
//
//    func convertStringToURLToImage(from string: String) -> UIImage? {
//        let url = URL(string: string)
//        if let data = try? Data(contentsOf: url!) {
//            return UIImage(data: data)
//        }
//        return nil
//    }
}
