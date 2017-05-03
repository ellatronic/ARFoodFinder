//
//  DetailViewController.swift
//  ARFoodFinder
//
//  Created by Ella on 5/1/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var toWebViewButton: UIButton!

    var place: Place?

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = place?.name
        priceLabel.text = convertToDollarSigns(tier: place!.tier)
        addressLabel.text = place?.formattedAddress
        userNameLabel.text = place?.userName
        tipTextLabel.text = place?.tipText
        featuredImage.image = place?.convertStringToURLToImage(from: (place?.photoURL)!)
        userImage.image = place?.convertStringToURLToImage(from: (place?.userImageURL)!)
        

        if (place?.isOpen)! {
            isOpenLabel?.text = "Open"
            isOpenLabel?.textColor = UIColor(red: 63/255.0, green: 195/255.0, blue: 128/255.0, alpha: 1)
        } else {
            isOpenLabel?.text = "Closed"
            isOpenLabel?.textColor = UIColor(red: 248/255.0, green: 40/255.0, blue: 22/255.0, alpha: 1)
        }
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func toWebView(_ sender: UIButton) {
    }

    // MARK: - Helper Functions
    func convertToDollarSigns(tier: Int) -> String {
        switch tier {
        case 1: return "$";
        case 2: return "$$";
        case 3: return "$$$";
        case 4: return "$$$$";
        default: return "Price not available"
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}
