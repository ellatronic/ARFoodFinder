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
    var id: String
    var name: String
    var formattedPhone: String

    init(id: String, name: String, formattedPhone: String) {
        self.id = id
        self.name = name
        self.formattedPhone = formattedPhone
    }

    static func create(from dictionary: [String: Any]) -> Place? {
        guard let venue = dictionary["venue"] as? [String: Any] else { return nil }
        guard let id = venue["id"] as? String else { return nil }
        guard let name = venue["name"] as? String else { return nil }

        guard let contact = venue["contact"] as? [String: Any] else { return nil }
        guard let formattedPhone = contact["formattedPhone"] as? String else { return nil }

//        guard let

        
        return Place(id: id, name: name, formattedPhone: formattedPhone)
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
