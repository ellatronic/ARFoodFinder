//
//  DetailViewController.swift
//  ARFoodFinder
//
//  Created by Ella on 5/1/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit
import QuartzCore

class DetailViewController: UIViewController {
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var toWebViewButton: UIButton!

    var place: Place?
    let apiManager = APIManager()
    var imageURLs = [String]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = place?.name
        priceLabel.text = convertToDollarSigns(tier: place!.tier)
        addressLabel.text = place?.formattedAddress
        userNameLabel.text = place?.userName
        tipTextLabel.text = place?.tipText
        featuredImage.image = place?.convertStringToURLToImage(from: (place?.photoURL)!)
        userImage.image = place?.convertStringToURLToImage(from: (place?.userImageURL)!)

        toWebViewButton.setBackgroundImage(#imageLiteral(resourceName: "FourSquareButton"), for: .normal)
//        cameraButton.setBackgroundImage(#imageLiteral(resourceName: "CameraButton-Selected"), for: .highlighted)
        toWebViewButton.adjustsImageWhenHighlighted = false
        toWebViewButton.frame = CGRect(x: (self.view.bounds.size.width / 2) - 97.5, y: self.view.bounds.size.height - 53, width: 195, height: 35)
        toWebViewButton.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleBottomMargin]

        if (place?.isOpen)! {
            isOpenLabel?.text = "Open"
            isOpenLabel?.textColor = UIColor(red: 63/255.0, green: 195/255.0, blue: 128/255.0, alpha: 1)
        } else {
            isOpenLabel?.text = "Closed"
            isOpenLabel?.textColor = UIColor(red: 248/255.0, green: 40/255.0, blue: 22/255.0, alpha: 1)
        }

        infoView.layer.masksToBounds = false
        infoView.layer.shadowColor = UIColor.lightGray.cgColor
        infoView.layer.shadowOffset = CGSize(width: 5, height: 5)
        infoView.layer.shadowRadius = 4
        infoView.layer.shadowOpacity = 0.5

        apiManager.loadVenuePhotos(forVenue: (place?.id)!) { (imageURLs) in
            self.imageURLs = imageURLs
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    // MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func toWebView(_ sender: UIButton) {
        self.showWebInfoView(forPlace: place!)
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

    func convertStringToURLToImage(from string: String) -> UIImage? {
        let url = URL(string: string)
        if let data = try? Data(contentsOf: url!) {
            return UIImage(data: data)
        }
        return nil
    }

    func showWebInfoView(forPlace place: Place) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.venueID = place.id
        self.present(viewController, animated: true, completion: nil)
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.photoImageView.image = convertStringToURLToImage(from: imageURLs[indexPath.row])
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        return cell
    }
}
