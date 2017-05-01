//
//  WebViewController.swift
//  ARFoodFinder
//
//  Created by Ella on 4/27/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backButton: UIButton!
    var venueID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        view.addSubview(webView)
        guard let id = venueID  else { return }
        print(id)
        if let url = URL(string: "https://foursquare.com/v/\(id)?ref=U0H3VHFNJFUGNIMPPZWEM5YQ5SLY2TLCBQNWZBYKYVYVX5AL") {
            print(url)
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }

//        backButton.setImage(#imageLiteral(resourceName: "BackChevron"), for: .normal)
//        UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
//        backButton.imageEdgeInsets = UIEdgeInsetsMake(4, 6, 4, backButton.frame.size.width)
//        cameraButton.setBackgroundImage(#imageLiteral(resourceName: "CameraButton-Selected"), for: .highlighted)
//        cameraButton.adjustsImageWhenHighlighted = false
//        .frame = CGRect(x: (self.view.bounds.size.width / 2) - 37.5, y: self.view.bounds.size.height - 95, width: 75, height: 75)
//        cameraButton.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleBottomMargin]
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
